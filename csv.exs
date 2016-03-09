defmodule CSV do
  def sigil_v(string, _opts) do
    string
    |> lines
    |> process
  end

  defp lines(string),
  do: String.split(string, "\n", trim: true)

  defp process([]), do: []
  defp process([headers | rest]) do
    headers = process_headers(headers)
    rest = Enum.map(rest, &cells/1)

    Enum.map(rest, &Enum.zip(headers, &1))
  end

  defp process_headers(headers) do
    headers
    |> String.split(",")
    |> Enum.map(&String.to_atom/1)
  end

  defp cells(string) do
    string
    |> String.split(",")
    |> Enum.map(&toFloat/1)
  end

  defp toFloat(word) do
    case Float.parse(word) do
      {float, ""} -> float
      _ -> word
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [sigil_v: 2]
    end
  end
end

defmodule Test do
  use CSV

  csv = ~v"""
  Item,Qty,Price
  Teddy bear,4,34.95
  Milk,1,2.99
  Battery,6,8.00
  """

  IO.inspect csv
end
