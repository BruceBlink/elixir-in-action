# Todo

**To-do list**

## Using

```cmd
iex -S mix
iex(1)> {:ok, todo_server} = Todo.Server.start()
iex(2)> Todo.Server.add_entry(todo_server,
          %{date: ~D[2023-12-19], title: "Dentist"}
          )
iex(3)> Todo.Server.entries(todo_server, ~D[2023-12-19])
[%{date: ~D[2023-12-19], id: 1, title: "Dentist"}]

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/todo>.
