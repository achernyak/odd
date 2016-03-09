defmodule CSV do
  def sigil_v(string, _opts) do
    string
    |> lines
    |> Enum.map(&cells/1)
  end

  defp lines(string),
  do: String.split(string, "\n", trim: true)

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
  1,2,3.14
  cat,dog
  """

  IO.inspect csv
end
