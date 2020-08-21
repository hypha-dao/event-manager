defmodule EventManager.Plugins.Discord do
  alias EventManager.Plugins.Discord
  alias EventManager.Utils


  defmodule FieldInfo do
    defstruct [:content, :title, :author_name, :description, :image, :url, :footer_text]
  end


  defstruct [
    :api_url,
    :fields,
    field_info: FieldInfo.__struct__
  ]

  def new(%{type: "discord", api_url: api_url, field_info: field_info, fields: fields}) do
    %Discord{
      api_url: api_url,
      field_info: Utils.struct_from_map(field_info, as: %FieldInfo{}),
      fields: fields
    }
  end

  def generate_payload(%Discord{field_info: infos, fields: fields}) do
    %{
      "username" => "hypha",
      "avatar_url" => "https://avatars0.githubusercontent.com/u/64083170?s=200&v=4",
      "embeds" => [prepare_embeds(infos, fields)]
    }
  end

  defp prepare_embeds(%FieldInfo{} = field_info, fields) do
    %{
      "author" => %{
        "name" => Map.get(field_info, :author_name)
      },
      "title" => Map.get(field_info, :title),
      "url" => Map.get(field_info, :url),
      "description" => Map.get(field_info, :description),
      "image" => %{
        "url" => Map.get(field_info, :image)
      },
      "fields" => prepare_fields(fields)
    }
  end

  defp prepare_fields(fields) when is_map(fields) and fields != %{} do
    {fields, _} =
      Enum.reduce(fields, {[], 0}, fn {k,v}, {acc_fields, index} ->
        new_field = %{
          "name" => k,
          "value" => v,
          "inline" => true
        }

        { [new_field | acc_fields], index + 0.5 }
      end)

    fields
  end

  defp prepare_fields(_), do: []

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
