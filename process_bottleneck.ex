defmodule Server do
  def start do
    spawn(fn -> loop() end)
  end

  def send_msg(server, msg) do
    send(server, {self(), msg})
    receive do
      {:response, response} -> response
    end
  end

  defp loop do
    receive do
      {caller, msg} ->
        Process.sleep(1000)
        send(caller, {:response, msg})        # code
    end
    loop()
  end
end

# use the server
server = Server.start()
Enum.each(
   1..5,
   fn i ->
     spawn(fn ->
       IO.puts("Sending msg ##{i}")
       response = Server.send_msg(server, i)
       IO.puts("Response: #{response}")
     end)
   end
)
