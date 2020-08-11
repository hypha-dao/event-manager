defmodule EventManager.Repository.Metadata do

  @new_proposal %{
    action_name: ["create", "update"],
    action_acct: "seedsprpslsx",
    channels: [
      %{
        type: "discord",
        api_url: "https://discordapp.com/api/webhooks/742742973787144252/8rHAimYM91oUUTRf-UgoNhr53wZkq0yi09nmnrvNmcOxtCnjodMfmH1eVXf5FrFl6TZw",
        vars: ["creator", "recipient", "quantity", "title", "summary", "description", "image", "url"],
        fields: %{
          content: "${{creator}} created new Proposal",
          title: "${{title}}",
          author_name: "${{creator}}",
          description: "${{description}}",
          image: "${{image}}",
          url: "${{url}}",
          footer_text: "${{summary}}"
        }
      }
    ]
  }

  def fetch_metadata() do
    [@new_proposal]
  end

  def search_metadata(action_name, action_account) do
    fetch_metadata()
    |> Enum.filter(&(filter_metadata(&1, action_name, action_account)))
  end

  defp filter_metadata(%{action_name: action} = params, action_name, action_account)
    when is_binary(action) do

      action == action_name and Map.get(params, :action_acct) == action_account
  end

  defp filter_metadata(%{action_name: actions} = params, action_name, action_account)
    when is_list(actions) do

    Enum.member?(actions, action_name) and Map.get(params, :action_acct) == action_account
  end

end
