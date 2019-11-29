defmodule Fuel.Ctx do
  @moduledoc """
  Provides functions for interacting with a `ctx`.

  The `ctx` is based on the golang `context.Context` and provides many of the same functional features.

  Using a `ctx` provides a common thread of data that can be used all through your application.
  It can be used in plug, grpc, graphql or just within your application to facilitate testing.

  You can include things like

  * implementation of behaviours
  * Authentication information
  * ids - request, trace etc
  * deadlines
  * arbitrary values

  @see https://github.com/tsloughter/ctx
  """

  @ctx_key :ctx

  @type t :: :ctx.t()

  @type source :: Keyword.t() | map()
  @type behaviour :: module
  @type impl :: module

  @doc "Fetch a new deadline"
  defdelegate new(), to: :ctx

  @doc "Fetch a new deadline"
  defdelegate background(), to: :ctx

  @doc "Set a value at a key in the context. Any valid term may be used as a key"
  defdelegate set(ctx, key, value), to: :ctx

  @doc "Get a value at a key. Missing values will raise a `KeyError`"
  defdelegate get(ctx, key), to: :ctx

  @doc "Get a value at a key. Missing values will return the default"
  defdelegate get(ctx, key, default), to: :ctx

  @doc "provides a new ctx with the given value"
  defdelegate with_value(key, value), to: :ctx

  @doc "Store a value on "
  defdelegate with_value(ctx, key, value), to: :ctx

  @doc "Provide a new ctx with the given values"
  defdelegate with_values(map), to: :ctx

  @doc "Provide a new ctx with a deadline set to elapse after the given time period"
  defdelegate with_deadline_after(value, time_unit), to: :ctx

  @doc "Set a deadline on an existing ctx"
  defdelegate with_deadline_after(ctx, value, time_unit), to: :ctx

  @doc "true if the deadline has not yet exceeded. false"
  defdelegate deadline(ctx), to: :ctx

  @doc """
  True when the time is earlier than the deadline. False if the deadline has elapsed
  """
  defdelegate done(ctx), to: :ctx

  @spec deadline_exceeded?(t()) :: boolean
  def deadline_exceeded?(ctx),
    do: not :ctx.done(ctx)

  @doc "Fetches a ctx from a kw list or map or returns a new one"
  @spec ctx_from(source | nil) :: t()
  def ctx_from(nil),
    do: :ctx.new()

  def ctx_from(options) when is_map(options),
    do: Map.get(options, @ctx_key, :ctx.background())

  def ctx_from(options) when is_list(options),
    do: Keyword.get(options, @ctx_key, :ctx.background())

  @doc "puts a ctx into a kwlist or map"
  @spec ctx_into(:ctx.t(), source()) :: source()
  def ctx_into(ctx, source) when is_map(source),
    do: Map.put(source, @ctx_key, ctx)

  def ctx_into(ctx, source) when is_list(source),
    do: Keyword.put(source, @ctx_key, ctx)

  @doc """
  Store the implementation of a behaviour in a context

  This is useful for changing out behaviours in things like tests where you want to use Mox.

  @see `fetch_impl/2`, `fetch_impl/3`
  """
  @spec with_impl(:ctx.t(), behaviour, impl) :: :ctx.t()
  def with_impl(ctx, behaviour, impl),
    do: :ctx.set(ctx, {:impl, behaviour}, impl)

  @doc """
  Fetches an implementation from the given context.

  If no implementation has been explicitly provided, use the behaviour module as the implementation
  """
  @spec fetch_impl(:ctx.t(), behaviour_and_impl :: module) :: impl()
  def fetch_impl(ctx, behaviour),
    do: :ctx.get(ctx, {:impl, behaviour}, behaviour)

  @doc """
  Fetches the implementation for the given behavioru from the given context.

  If no implementation has been explicitly provided, fall back to the deafult implementation provided
  """
  @spec fetch_impl(:ctx.t(), behaviour, default_impl :: impl) :: impl
  def fetch_impl(ctx, behaviour, default_impl),
    do: :ctx.get(ctx, {:impl, behaviour}, default_impl)
end
