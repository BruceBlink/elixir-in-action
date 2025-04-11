defmodule EchoServer do
  use GenServer

  @impl GenServer
  def handle_call(some_request, server_state) do
    # Handle the incoming request and return a response
    {:reply, some_request, server_state}
  end
end
