defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()  # 调用回调模块的 init初始化状态
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, state) do
    receive do
      {:call, request, caller} ->    # 增加一个 :caller请求类型
        {response, new_state} =
          callback_module.handle_call(request, state)  # 调用回调模块的 handle_call处理请求
          send(caller, {:response, response})  # 发送响应给调用者
          loop(callback_module, new_state)  # 继续循环，使用新的状态
      {:cast, request} -> # 处理 cast 请求
        new_state =
          callback_module.handle_cast(request, state)  # 调用回调模块的 handle_cast处理请求
          loop(callback_module, new_state)  # 继续循环，使用新的状态
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})  # 发送请求和调用者的 PID, 增加一个 :caller请求类型
    receive do
      {:response, response} -> # 等待响应
        response  # 返回响应
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})  # 发送请求
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
    {value, state}  # 返回响应和当前状态
    # 可以简写如下形式
    # {Map.get(state, key) ,state}
  end

  def handle_cast({:put, key, value}, state) do
    Map.put(state, key, value)  # 更新状态
  end

  def start do
    ServerProcess.start(__MODULE__)  # 启动服务器进程，传入当前模块作为回调模块
  end

  def put(server_pid, key, value) do
    ServerProcess.cast(server_pid, {:put, key, value})  # 调用服务器进程的 put 方法
  end

  def get(server_pid, key) do
    ServerProcess.call(server_pid, {:get, key})  # 调用服务器进程的 get 方法
  end

end
