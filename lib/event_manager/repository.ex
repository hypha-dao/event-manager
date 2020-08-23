defmodule EventManager.Repository do
  alias EventManager.Repository
  @moduledoc """

  """
  def parse_metadata(channels, data) when is_list(channels) do
    Enum.reduce(channels, [], fn channel_info, acc ->
      acc ++ parse_metadata(channel_info, data)
    end)
  end
  def parse_metadata(%{channels: channels}, data) when is_map(data) do
    channels
    |> Enum.map(&(parse_variables(&1, data)))
  end

  def parse_metadata(%{channels: channels}, _), do: channels

  def parse_metadata(_, _), do: []



  defp parse_variables(%{field_info: field_info, fields: fields} = channels, data)
    when is_map(field_info) and is_list(fields) do
      channels
      |> Map.merge(parse_variables(%{field_info: field_info}, data))
      |> Map.merge(parse_variables(%{fields: fields}, data))

  end

  defp parse_variables(%{field_info: field_info} = channel, data) do

    parsed_data =
      for {k, v} <- field_info, into: %{} do
        {k, parse_text(v, data)}
      end

    Map.put(channel, :field_info, parsed_data)
  end

  defp parse_variables(%{fields: fields} = channel, data) do
    parsed_data =
      for k <- fields, into: %{} do
        exact_key = Repository.Metadata.get_key(k)
        {exact_key, Map.get(data, k)}
      end

    Map.put(channel, :fields, parsed_data
    )
  end

  defp parse_variables(channel, _data), do: channel

  defp parse_text(text, data) do
    Enum.reduce(data, text, fn {k, v}, acc ->
      if String.contains?(acc, "${{#{k}}}") do
        String.replace(acc, "${{#{k}}}", v)
      else
        acc
      end

    end)
  end
end
