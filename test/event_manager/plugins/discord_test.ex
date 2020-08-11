defmodule EventManager.Plugins.DiscordTest do
  use ExUnit.Case

  alias EventManager.Plugins
  alias EventManager.Plugins.Discord
  alias EventManager.Repository

  @data %{
    "creator" => "seedsforlife",
    "title" =>  "(Example) \"Launch Partner\" Proposal",
    "summary" =>  "See details for an example Launch Partnership...",
    "description" =>  "Our ask: 170k Seeds for:\n\n120k to gift to our community. We'll create a garden-planting challenge and reward each person with 150 Seeds.\n\n40k for the \"Local Food Platform\" team. For our contributions to the local food movement and creating a healthier world. \n\nOur Offer:\n\nWe'll encourage people to use Seeds by giving a small discount and designing our platforms UI to ask for Seeds first.\n\nWe'll give a 10% & 15% discount to residents and citizens (respectively). \n\nWe ask that 1/2 of this discount is reimbursed in Seeds (capped at 10k Seeds.) \n\nWe're going to be using SEEDS anyway and would love to have this promotion to help us further the local food movement and create a healthier Society!\n\nThank you. \n\n",
    "image" =>  "https://seeds-service.s3.amazonaws.com/development/57112531-4869-4c06-b0b3-6dc17f39b0b9/cf296885-2184-4349-9582-d4ded33f9de3-1920.jpg"
  }

  describe "Discord Plugin Test" do
    test "Discord notification test " do
      discord_params =
        EventManager.Repository.Metadata.search_metadata("create", "seedsprpslsx")
        |> List.first()
        |> Repository.parse_metadata(@data)
        |> List.first()
        |> Discord.new()

      assert {:ok, _resp} = Plugins.send_request(discord_params)
    end
  end
end
