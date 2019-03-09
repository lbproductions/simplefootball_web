defmodule SimplefootballWeb.ArrayHelpers do
  def split(list) do
    len = round(length(list) / 2)

    Enum.split(list, len)
  end

  def uniq(list) do
    uniq(list, MapSet.new())
  end

  defp uniq([x | rest], found) do
    if MapSet.member?(found, x) do
      uniq(rest, found)
    else
      [x | uniq(rest, MapSet.put(found, x))]
    end
  end

  defp uniq([], _) do
    []
  end
end
