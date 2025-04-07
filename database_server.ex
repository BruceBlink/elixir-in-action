defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        query_result = run_query(query_def)
        send(caller, {:query_result, result})
    end
    loop()
  end

  defp run_query(query_def) do
    # Simulate a database query execution
    Process.sleep(1000) # Simulate delay
    "#{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

end
