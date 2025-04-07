defmodule DatabaseServer do
  def start do
    spawn(fn ->
      connection = :rand.uniform(1000) # Simulate a database connection
      loop(connection)
    end)
  end

  defp loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        query_result = run_query(connection, query_def)  # Simulate a database query execution
        send(caller, {:query_result, query_result})
    end
    loop(connection)
  end

  defp run_query(connection, query_def) do
    # Simulate a database query execution
    Process.sleep(2000) # Simulate delay
    "Connection #{connection}: #{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 -> {:error, :timeout} # Timeout after 5 seconds
    end
  end

end
