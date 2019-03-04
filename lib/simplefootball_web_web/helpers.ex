defmodule Helpers do
  @spec drop_nil(struct) :: struct
  def drop_nil(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> drop_nil()
  end

  def drop_nil(map = %{}) when map_size(map) == 0, do: nil

  @spec drop_nil(map) :: map
  def drop_nil(map) when is_map(map) do
    map
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      cleaned_val = drop_nil(v)

      if cleaned_val == nil do
        acc
      else
        Map.put(acc, k, cleaned_val)
      end
    end)
  end

  def drop_nil([]), do: nil

  @spec drop_nil(list) :: list
  def drop_nil(list) when is_list(list) do
    list
    |> Enum.reduce([], fn v, acc ->
      cleaned_val = drop_nil(v)

      if cleaned_val == nil do
        acc
      else
        acc ++ [cleaned_val]
      end
    end)
    |> case do
      [] -> nil
      _ = list -> list
    end
  end

  def drop_nil(elem) do
    elem
  end
end
