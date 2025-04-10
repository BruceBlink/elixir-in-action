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

defmodule KeyValStore do
    use GenServer

    def init(_) do
        :timer.send_interval(5000, :cleanup)
        {:ok, %{}}
    end

    def handle_info(:cleanup, state) do
        IO.puts "preforming cleanup..."
        {:noreply, state}
    end
end

defmodule CleanupServer do
    use GenServer

    # 初始化时启动定时器
    def init(_) do
      :timer.send_interval(3000, self(), :cleanup)  # 每30秒发送:cleanup消息
      {:ok, %{data: [], last_cleanup: nil}}
    end

    # 处理普通消息
    def handle_info(:cleanup, state) do
      new_state = do_cleanup(state)
      IO.puts "#{new_state.last_cleanup} preforming cleanup..."
      {:noreply, new_state}
    end

    defp do_cleanup(state) do
      # 清理过期数据
      %{state | data: [], last_cleanup: DateTime.utc_now()}
    end
end
