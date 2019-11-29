if Code.ensure_loaded?(Plug) do
  defmodule Fuel.Ctx.Plug do
    @moduledoc """
    Get and set a ctx in a plug connection
    """
    @behaviour Plug

    @impl true
    def init(opts \\ []), do: opts

    @impl true
    def call(%{private: %{Fuel => %{ctx: _ctx}}} = conn, _opts), do: conn

    def call(conn, _opts) do
      with_ctx(conn, Fuel.Ctx.background())
    end

    @doc "sets a context onto the connection"
    @spec with_ctx(Plug.Conn.t(), Fuel.Ctx.t()) :: Plug.Conn.t()
    def with_ctx(conn, ctx) do
      fuel = Map.get(conn.private, Fuel, %{})
      fuel = Fuel.Ctx.ctx_into(ctx, fuel)
      Plug.Conn.put_private(conn, Fuel, fuel)
    end

    @doc "fetch a ctx from the conn. Returns an empty ctx if not set"
    @spec fetch_ctx(Plug.Conn.t()) :: Fuel.Ctx.t()
    def fetch_ctx(%{private: %{Fuel => %{ctx: ctx}}}), do: ctx
    def fetch_ctx(_), do: Fuel.Ctx.background()
  end
end
