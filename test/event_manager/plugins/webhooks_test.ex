defmodule EventManager.Plugins.WebHooksTest do
  use ExUnit.Case
  alias EventManager.Plugins
  alias Plugins.WebHooks

  @sample_data %{
    url: "https://app-dev.joinseeds.com/api/passport/v2/setup",
    payload: %{},
    method: "GET"
  }

  test "new/1 creates new webhooks struct" do
    assert %WebHooks{} = webhook = WebHooks.new(@sample_data)
    assert webhook.url == @sample_data.url
    assert webhook.method == @sample_data.method
    assert webhook.payload == @sample_data.payload
  end

  test "send_request/1 action" do
    assert {:error, :INVALID_URL} == Plugins.send_request(%WebHooks{url: nil})
    assert {:ok, _resp} = WebHooks.new(@sample_data) |> Plugins.send_request()
    assert {:error, _} = Plugins.send_request(%WebHooks{url: "bad-url", method: "GET"})
  end

end
