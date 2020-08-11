defmodule EventManager.RepositoryTest do
  use ExUnit.Case
  alias EventManager.Repository

  @valid_metadata %{
    channels: [
      %{
        vars: ["var1", "var2", "var3"],
        fields: %{
          v1: "var1: ${{var1}}",
          v2: "var2: ${{var2}}",
          v3: "var3: ${{var3}}"
        }
      }
    ]
  }

  @data %{"var1" => "v-1", "var2" => "v-2"}

  describe "Repository test" do
    test "parse_metadata/2 parses variables to fields" do
      assert [%{fields: fields}] = Repository.parse_metadata(@valid_metadata, @data)
      assert fields == %{v1: "var1: v-1", v2: "var2: v-2", v3: nil}

      assert [] == Repository.parse_metadata(%{channels: []}, nil)
      assert nil == Repository.parse_metadata(%{}, @data)
    end
  end
end
