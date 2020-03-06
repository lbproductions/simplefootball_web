defmodule SimplefootballWeb.StringHelpers do
  def nilIfEmpty(string) do
    if string == "" do
      nil
    else
      string
    end
  end

  def trim(string) when is_nil(string), do: nil

  def trim(string) do
    String.trim(string)
  end

  def contains(string, content) when is_nil(string), do: false

  def contains(string, content) do
    String.contains?(string, content)
  end

  def split(string, _separator, _trim) when is_nil(string), do: nil

  def split(string, separator, trim) do
    String.split(string, separator, trim: trim)
  end
end
