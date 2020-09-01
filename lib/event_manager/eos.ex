defmodule EventManager.Eos do

  def unpack_data(hash, acc_name \\ "publsh.hypha", action \\ "event") do
    if is_binary(hash) do

      cmds = ["-u", "https://node.hypha.earth", "convert", "unpack_action_data", acc_name, action, hash]
      case System.cmd("cleos", cmds) do
        {"", _} ->
          %{}

        {resp, _} ->
          Jason.decode!(resp)
          |> prepare_data()
      end

    else
      hash
    end
  end


  def prepare_data(%{"values" => values}) when is_list(values) do
    Enum.reduce(values, %{}, fn(%{"key" => key, "value" => [_type, exact_value]}, acc) ->
      Map.put(acc, key, exact_value)
    end)
  end

  def prepare_data(data), do: data
end
