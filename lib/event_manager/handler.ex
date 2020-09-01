defmodule EventManager.Handler do
  alias EventManager.Repository.Metadata
  alias EventManager.Repository
  alias EventManager.Plugins
  alias EventManager.Plugins.Discord

  def handle_action(%{"act" => %{ "account" => acct, "name" => name, "data" => data}}) do
    data
    |> EventManager.Eos.unpack_data()
    |> handle_data(acct, name)
  end

  def handle_action(_), do: nil

  def handle_data(data, acct, name) do
    Metadata.search_metadata(name, acct)
    |> Repository.parse_metadata(data)
    |> Enum.map(&handle_channel/1)

  end

  def handle_channel(channel) do
    case channel do
      %{type: "discord"} ->
        channel
        |> Discord.new()
        |> Plugins.send_request()
        |> IO.inspect()

      _ ->
        nil
    end
  end
end
