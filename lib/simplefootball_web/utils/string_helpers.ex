defmodule SimplefootballWeb.StringHelpers do
  def nilIfEmpty(string) do
    if string == "" do
      nil
    else
      string
    end
  end
end
