defmodule EventManager.Listener do

  use GenServer

  require Logger
  alias EventManager.EventHandler

  @collection "action_traces"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    initial_state = %{
      mongo_pid: nil,
      worker_pid: nil,
      token: nil
    }
    monitor_process()

    {:ok, initial_state}
  end

  @impl true
  def handle_info(:watch, %{mongo_pid: m_pid, worker_pid: w_pid} = state)
    when is_pid(m_pid) and is_pid(w_pid) do

    if Process.alive?(m_pid) and Process.alive?(w_pid) do
      %{mongo_pid: m_pid, worker_pid: w_pid}
    else
      Logger.error("Blockchain Watcher Process Failed")
      Logger.info("Killing old process")
      Process.exit(m_pid, :kill)
      Process.exit(w_pid, :kill)
      spawn_process(state, self())

    end
  end

  @impl true
  def handle_info({:update_token, new_token}, state) do
    case new_token do
      %{"_data" => token} ->
        {:noreply, Map.put(state, :token, token)}

      _ ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_info({:new_data, data}, state) do
    EventHandler.broadcast_event(data)

    {:noreply, state}
  end


  defp get_mongo_topology() do
    mongo_url = Application.get_env(:plants, :eos_mongo_url)
    case Mongo.start_link(url: mongo_url) do
      {:ok, pid} ->
        pid

      _ ->
        Logger.info("Reconnecting Mongo ....")
        get_mongo_topology()
    end
  end

  defp monitor_process(timeout \\ 5 * 1000) do
    Process.send_after(self(), :watch, timeout)
  end


  defp spawn_process(state, pid) do
    Logger.info("Spawning New Process for watching blockchain changes")

    resume_token = Map.get(state, :token)
    mongo_pid = get_mongo_topology()
    watcher_pid = spawn(fn -> watch_collection(mongo_pid, pid, resume_token) end)

    Logger.info("Executed new Watcher Process")
    %{mongo_id: mongo_pid, watcher_id: watcher_pid}
  end


  defp watch_collection(mongo_pid, worker_pid, resume_token) do
    cursor =
      Mongo.watch_collection(mongo_pid, @collection, [], fn doc ->
        Process.send_after(worker_pid,  {:update_token, doc}, 1000)
      end, [start_after: resume_token])

    Enum.each(cursor, fn %{"fullDocument" => doc} ->
      Process.send_after(worker_pid,  {:new_data, doc}, 1000)
    end)
  end


end
