defmodule KeyValueStore do
    use GenServer

    def init(_) do
        {:ok, %{}}
    end

    def handle_cast({:put, key, value}, state) do
        {:noreply, Map.put(state, key, value)}
    end

    def handle_call({:get, key}, _, state) do
        {:reply, Map.get(state, key), state}
    end

    def start do
        GenServer.start(__MODULE__, nil)
    end

    def put(server_pid, key, value) do
        GenServer.cast(server_pid, {:put, key, value})
    end
    def get(server_pid, key) do
        GenServer.call(server_pid, {:get, key})
    end
end
