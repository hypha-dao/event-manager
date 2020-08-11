defmodule EventManager.Utils do
  @moduledoc """
    Utility functions
  """

  @doc """
    Converts atom maps to string Map

    ## Examples

      iex> to_string_map(%{a: 1, b: %{c: 1}})
      %{"a" => 1, "b" => %{"c" => 1}}


  """
  def to_string_map(params) when is_map(params) do
    for {k, v} <- params, into: %{} do
      new_key = if is_atom(k), do: Atom.to_string(k), else: k

      if is_map(v) do
        {new_key, to_string_map(v)}

      else
        {new_key, v}
      end
    end
  end

end
