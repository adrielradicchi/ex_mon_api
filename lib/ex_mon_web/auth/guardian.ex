defmodule ExMonWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon

  alias Ecto.UUID
  alias ExMon.{Repo, Trainer}
  def subject_for_token(trainer, _claims) do
    sub = to_string(trainer.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ExMon.fetch_trainer()
  end

  def authenticate(%{"id" => trainer_id, "password" => password}) do
    trainer_id
    |> UUID.cast()
    |> validate_id_trainer()
    |> validate_trainer(password)
  end

  defp validate_id_trainer({:ok, id}), do: get_trainer(id)
  defp validate_id_trainer(:error), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp get_trainer(id), do: Repo.get(Trainer, id)

  defp validate_trainer(trainer, password) when not is_nil(trainer) and (byte_size(password) >= 6), do: validate_password(trainer, password)
  defp validate_trainer(trainer, _password) when is_nil(trainer), do: {:error, %{message: "Trainer not found", status: 404}}

  defp validate_password(%Trainer{password_hash: hash} = trainer, password) do
    Argon2.verify_pass(password, hash)
    |> create_token(trainer)
  end

  defp validate_password({:error, _reason} = error, _password), do: error

  defp create_token(is_valid_password, trainer) when is_valid_password == true do
    {:ok, token, _claims} = encode_and_sign(trainer)
    {:ok, token}
  end

  defp create_token(is_valid_password, _trainer) when is_valid_password == false, do: {:error, %{message: "Trainer unauthorized", status: 401}}
end
