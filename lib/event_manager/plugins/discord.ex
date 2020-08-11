defmodule EventManager.Plugins.Discord do
  alias EventManager.Plugins.Discord
  alias EventManager.Utils


  defmodule Fields do
    defstruct [:content, :title, :author_name, :description, :image, :url, :footer_text]
  end

  defstruct [
    :api_url,
    info: Fields.__struct__
  ]

  def new(%{type: "discord", api_url: api_url, fields: fields}) do
    %Discord{
      api_url: api_url,
      info: Utils.struct_from_map(fields, as: %Fields{})
    }
  end

  def generate_payload(%Discord{info: infos}) do
    %{
      "username" => "hypha",
      "avatar_url" => "https://avatars0.githubusercontent.com/u/64083170?s=200&v=4",
      "embeds" => [prepare_embeds(infos)]
    }
  end

  defp prepare_embeds(%Fields{} = fields) do
    %{
      "author" => %{
        "name" => Map.get(fields, :author_name)
      },
      "title" => Map.get(fields, :title),
      "url" => Map.get(fields, :url),
      "description" => Map.get(fields, :description),
      "image" => %{
        "url" => Map.get(fields, :image)
      }
    }
  end

end

defimpl EventManager.Plugins, for: EventManager.Plugins.Discord  do
  alias EventManager.Plugins.Discord
  alias EventManager.Plugins.WebHooks

  def send_request(%Discord{api_url: api_url} = discord) do
    payload = Discord.generate_payload(discord)
    IO.inspect payload

    WebHooks.new(%{"url" => api_url, "payload" => payload})
    |> EventManager.Plugins.send_request()
  end
end
