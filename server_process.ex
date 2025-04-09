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
