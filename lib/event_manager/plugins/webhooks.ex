defmodule EventManager.Plugins.WebHooks do
  alias EventManager.Utils
  alias __MODULE__, as: WebHooks

  defstruct [:url, :method, :payload, :headers]

  def new(params) do
    params = Utils.to_string_map(params)

    %WebHooks{
      url: Map.get(params, "url"),
      method: Map.get(params, "method", "POST"),
      payload: Map.get(params, "payload", %{}),
      headers: Map.get(params, "headers", [{"Content-Type", "application/json"}])
    }

  end
end

defimpl EventManager.Plugins, for: EventManager.Plugins.WebHooks  do
  alias EventManager.Plugins.WebHooks

  @doc """
    implementation for sending request for webHooks

    ## Examples

        iex> send_request(%WebHooks{})
        {:ok, response}

        iex> send_request(%WebHooks{url: invalid_url})
        {:error, :INVALID_URL}

        iex> send_request(invalid_webhooks)
        {:error, err_response}

  """
  def send_request(%WebHooks{url: url, method: method, headers: header, payload: payload})
    when is_binary(url) do

      case method do
      "POST" ->
        HTTPoison.post(url, Jason.encode!(payload), header)

      "GET" ->
        HTTPoison.get(url, Jason.encode!(payload), header)

      _ ->
        {:error, :INVALID_METHOD}
    end
  end

  def send_request(_), do: {:error, :INVALID_URL}
end
