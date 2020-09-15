defmodule ExMon.Pokemon do
  @keys [:id, :name, :weight, :types]

  @enforce_keys @keys

  @derive Jason.Encoder
  defstruct @keys

  def build(%{"id" => id, "name" => name, "weight" => weight, "types" => types}) do
    %__MODULE__{
      id: id,
      name: name,
      weight: weight,
      types: parse_type(types)
    }
  end

  defp parse_type(types), do: Enum.map(types, fn item -> item["type"]["name"] end)
end