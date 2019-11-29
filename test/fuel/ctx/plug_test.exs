defmodule Fuel.Ctx.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Fuel.Ctx

  setup do
    c = conn(:get, "/foo")
    ctx = Ctx.with_values(%{foo: :bar})
    {:ok, %{conn: c, ctx: ctx}}
  end

  test "adds a context into the conn", x do
    c = Ctx.Plug.call(x.conn, [])
    assert c.private[Fuel].ctx
  end

  test "does not add a new context to the conn", x do
    c = Plug.Conn.put_private(x.conn, Fuel, %{ctx: x.ctx})

    new_conn = assert Ctx.Plug.call(c, [])
    assert new_conn.private[Fuel].ctx == x.ctx
  end

  test "adds a new ctx to the connection", x do
    c = Ctx.Plug.call(x.conn, [])
    assert c.private[Fuel].ctx
    refute c.private[Fuel].ctx == x.ctx

    new_conn = Ctx.Plug.with_ctx(c, x.ctx)
    assert new_conn.private[Fuel].ctx == x.ctx
  end

  test "fetches a ctx from the connection", x do
    new_conn = Ctx.Plug.with_ctx(x.conn, x.ctx)

    assert Ctx.Plug.fetch_ctx(new_conn) == x.ctx
  end

  test "adds a value to the ctx in the connection", x do
    new_conn =
      x.conn
      |> Ctx.Plug.with_ctx(x.ctx)
      |> Ctx.Plug.with_value(:barry, :the_dinosaur)

    ctx = new_conn.private[Fuel].ctx
    # does not change the existing values
    assert Ctx.get(ctx, :foo) == :bar
    # does add the new value
    assert Ctx.get(ctx, :barry) == :the_dinosaur
  end

  test "adds a value to the ctx in the connection with no prior ctx", x do
    new_conn = Ctx.Plug.with_value(x.conn, :barry, :the_dinosaur)
    assert Ctx.get(new_conn.private[Fuel].ctx, :barry) == :the_dinosaur
  end
end
