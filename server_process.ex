defmodule ServerProce do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()  # 调用回调模块的 init初始化状态
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, state) do
    receive do
      {request, caller} ->
        {response, new_state} =
          callback_module.handle_call(request, state)  # 调用回调模块的 handle_call处理请求
          send(caller, {:response, response})  # 发送响应给调用者
          loop(callback_module, new_state)  # 继续循环，使用新的状态
    end
  end

  def call(server_pid, request) do
    send(server_pid, {request, self()})  # 发送请求和调用者的 PID
    receive do
      {:response, response} -> # 等待响应
        response  # 返回响应
    end
  end

end

defmodule KeyValueStore do
  def init do
    %{}  # 初始化状态为一个空的 Map
  end
  def handle_call({:put, key, value}, state) do
    new_state = Map.put(state, key, value)  # 更新状态
    {:ok, new_state}  # 返回响应和新的状态
    # 可以简写如下形式
    # {:ok, Map.put(state, key, value)}
  end
  def handle_call({:get, key}, state) do
    value = Map.get(state, key)  # 获取值
    {:ok, value, state}  # 返回响应和当前状态
    # 可以简写如下形式
    # {:ok, Map.get(state, key)}
  end
end
