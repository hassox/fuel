defmodule Fuel.CtxTest do
  use ExUnit.Case, async: true

  alias Fuel.Ctx

  test "new/0 provides a new ctx" do
    assert Ctx.new() == :ctx.new()
  end

  test "background delegates to ctx" do
    assert Ctx.background() == :ctx.background()
  end

  test "set delegates to ctx" do
    ctx = :ctx.new()

    assert Ctx.set(ctx, :foo, :bar) == :ctx.set(ctx, :foo, :bar)
  end

  test "get delegates to ctx" do
    ctx = :ctx.with_values(%{foo: :bar})
    assert Ctx.get(ctx, :foo) == :ctx.get(ctx, :foo)

    ctx = :ctx.with_values(%{foo: :bar})
    assert Ctx.get(ctx, :foo, :yellow) == :ctx.get(ctx, :foo, :yellow)
  end

  test "with value delegates to ctx" do
    assert Ctx.with_value(:foo, :bar) == :ctx.with_value(:foo, :bar)
  end

  test "with_values delegates to ctx" do
    assert Ctx.with_values(%{foo: :bar}) == :ctx.with_values(%{foo: :bar})
  end

  describe "ctx_from/1" do
    test "nil" do
      assert Ctx.ctx_from(nil) == Ctx.new()
    end

    test "list" do
      assert Ctx.ctx_from([]) == Ctx.new()
      ctx = Ctx.with_values(%{foo: :bar})
      assert Ctx.ctx_from(ctx: ctx) == ctx
    end

    test "map" do
      assert Ctx.ctx_from(%{}) == Ctx.new()
      ctx = Ctx.with_values(%{foo: :bar})
      assert Ctx.ctx_from(%{ctx: ctx}) == ctx
    end
  end

  describe "ctx_into/2" do
    setup do
      {:ok, %{ctx: Ctx.with_values(%{foo: :bar})}}
    end

    test "into list", ctx do
      list = Ctx.ctx_into(ctx.ctx, foo: :bar)
      assert Keyword.get(list, :ctx) == ctx.ctx
    end

    test "into map", ctx do
      map = Ctx.ctx_into(ctx.ctx, %{foo: :bar})
      assert Map.get(map, :ctx) == ctx.ctx
    end
  end

  test "with_impl/3 it stores the implemntation and behaviour" do
    ctx = Ctx.new() |> Ctx.with_impl(Enumerable, Keyword)
    assert Ctx.get(ctx, {:impl, Enumerable}) == Keyword
  end

  test "fetch_impl/2" do
    assert Ctx.fetch_impl(Ctx.new(), Enumerable) == Enumerable
    ctx = Ctx.new() |> Ctx.with_impl(Enumerable, Keyword)
    assert Ctx.fetch_impl(ctx, Enumerable) == Keyword
  end

  test "fetch_impl/3" do
    assert Ctx.fetch_impl(Ctx.new(), Enumerable, Map) == Map

    ctx = Ctx.new() |> Ctx.with_impl(Enumerable, Keyword)
    assert Ctx.fetch_impl(ctx, Enumerable, Map) == Keyword
  end
end
