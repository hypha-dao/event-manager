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

  def struct_from_map(a_map, as: a_struct) do
    # Find the keys within the map
    keys =
      Map.keys(a_struct)
      |> Enum.filter(fn x -> x != :__struct__ end)

    processed_map =
      for key <- keys, into: %{} do
          # Process map, checking for both string / atom keys
          value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
          {key, value}
      end

      Map.merge(a_struct, processed_map)
  end

  def map_without_nil(params) do
    Enum.reduce(params, %{}, fn {k, v}, acc ->
      cond do
        is_nil(v) ->
          acc

        v == "" ->
          acc

        is_binary(v) and String.upcase(v) == "NULL" ->
          acc


        true ->
          Map.put(acc, k, v)
      end
    end)
  end

end
