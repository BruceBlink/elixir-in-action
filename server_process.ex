defmodule ServerProce do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()  # 调用回调模块的 init初始化状态
      loop(callback_module, initial_state)
    end)
  end

end
