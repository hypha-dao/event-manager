defmodule EventManager.Repository do

  @moduledoc """

  """
  def parse_metadata(%{channels: channels}, data) when is_map(data) do
    channels
    |> Enum.map(&(parse_variables(&1, data)))
  end

  def parse_metadata(%{channels: channels}, _), do: channels

  def parse_metadata(_, _), do: nil



  defp parse_variables(%{vars: vars, fields: fields} = channel, data)
    when is_list(vars) and is_map(fields) do

    parsed_fields =
      Enum.reduce(vars, fields, fn curr_var, acc_fields ->
        for {k, v} <- acc_fields, into: %{} do
          case Map.get(data, curr_var) do
            nil ->
              if String.contains?(v, "${{#{curr_var}}}") do
                {k, nil}
              else
                {k, v}
              end

            value ->
              {k, String.replace(v, "${{#{curr_var}}}", value)}
          end
        end
      end)

    channel
    |> Map.put(:fields, parsed_fields)

  end

  defp parse_variables(channel, _data), do: channel
end
