defmodule EventManager.EventHandler do
  @accounts_vars [
    "act.account",
    "act.data.from",
    "act.data.sponsor",
    "act.data.account",
    "act.data.user",
    "act.data.issuer"
  ]

  @event_name "NEW_TX"
  def handle_event(action) do
    IO.inspect action

  end

  def broadcast_event(%{"act" => %{"data" => data}} = action ) when is_map(data) do

    ["ALL" | extract_account_name(action)]
    |> Enum.map(&(broadcast(&1, @event_name, action)))

  end

  def broadcast_event(_), do: nil

  def extract_account_name(action) do
    @accounts_vars
    |> Enum.map(&(get_in(action, String.split(&1, "."))))
    |> Enum.filter(&is_binary/1)
  end

  defp broadcast(room, event, data) do
    EventManagerWeb.Endpoint.broadcast("EVENT:#{room}", event, data)
  end
end
