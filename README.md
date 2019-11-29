# Fuel

Provides some useful modules that help with building consistent applications.

# Ctx

Provides a context object similar to golangs `context.Context` that provides a way to thread data through a call-stack or even across process boundaries.

This is very useful for dependency injection especially when testing.

For example

```elixir

setup do
  ctx = 
    Fuel.Ctx.new()
    |> Fuel.Ctx.with_impl(MyBehaviour, MyBehaviourMock)
  
  {:ok, %{ctx: ctx}}
end

test "test my thing", ctx do
  options = Fuel.Ctx.ctx_into(ctx.ctx, [])

  MyBehaviourMock
  |> expect(:some_call, fn _, _ -> :ok end)

  assert :ok == MyThing.call_a_function("yay", options)
end
```

In your code:

```elixir
  def call_a_function(arg1, options) do
    with ctx <- Fuel.Ctx.ctx_from(options),
         my_behaviour <- Fuel.Ctx.fetch_impl(ctx, MyBehaviour) do
      
      my_behaviour.some_call(arg1, options)
    end
  end
```

Contexts are useful for more than just DI.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fuel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fuel, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fuel](https://hexdocs.pm/fuel).

