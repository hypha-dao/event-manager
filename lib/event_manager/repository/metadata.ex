defmodule EventManager.Repository.Metadata do

  # @new_proposal %{
  #   action_name: ["create", "update"],
  #   action_acct: "seedsprpslsx",
  #   channels: [
  #     %{
  #       type: "discord",
  #       api_url: "",
  #       vars: ["creator", "recipient", "quantity", "title", "summary", "description", "image", "url"],
  #       fields: %{
  #         content: "${{creator}} created new Proposal",
  #         title: "${{title}}",
  #         author_name: "${{creator}}",
  #         description: "${{description}}",
  #         image: "${{image}}",
  #         url: "${{url}}",
  #         footer_text: "${{summary}}"
  #       }
  #     }
  #   ]
  # }

  @publsh_hypha %{
    action_name: ["event"],
    action_acct: "publsh.hypha",
    channels: [
      %{
        type: "discord",
        api_url: Application.get_env(:event_manager, :dho_discord_url),
        field_info: %{
          title: "${{title}}",
          description: "${{description}}",
          author_name: "${{owner}}",
          url: "${{url}}"
        },
        fields: [
          "deferred_perc_x100",
          "husd_salary_per_phase",
          "hvoice_salary_per_phase",
          "hypha_salary_per_phase",
          "instant_husd_perc_x100",
          "seeds_escrow_salary_per_phase",
          "type"
        ]
      }
    ]
  }

  @keys_mapping %{
    "deferred_perc_x100" => "Deferred %",
    "husd_salary_per_phase" => "HUSD Per phase",
    "hvoice_salary_per_phase" => "HVOICE Per phase",
    "hypha_salary_per_phase" => "HYPHA Per phase",
    "instant_husd_perc_x100" => "HUSD %",
    "seeds_escrow_salary_per_phase" => "SEEDS Per phase"
  }

  def fetch_metadata() do
    [@publsh_hypha]
  end

  def get_key(key) do
    Map.get(@keys_mapping, key, key)
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
