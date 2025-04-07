async_query = fn query_def ->        # 外层函数，接收 query_def 参数
  spawn(fn ->                        # 内层 lambda（闭包）
    query_result = run_query.(query_def)  # 这里访问了外层的 query_def
    IO.puts(query_result)
  end)
end


defmodule MyModule do
  def sync_query1(query_def) do
    spawn(fn ->                        # 内层 lambda（闭包）
      query_result = run_query.(query_def)  # 这里访问了外层的 query_def
      IO.puts(query_result)
  end)
  end
end
# 这里是一个模拟的查询函数

async_query =
  fn query_def ->
    caller = self()  # 获取当前进程的 PID
    spawn(fn ->
      query_result = run_query.(query_def)  # 这里访问了外层的 query_def
      send(caller, {:query_result, query_result})  # 将结果发送回调用者
    end)
  end

Enum.each(1..5, &async_query.("query #{&1}"))
get_result =
  fn ->
    receive do
      {:query_result, result} -> result
    end
  end
