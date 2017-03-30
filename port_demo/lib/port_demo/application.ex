defmodule Top.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [worker(Top.Server, [nil])]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Top.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def report(), do: Top.Server.report()


  def report(key), do: Top.Server.report(key)

  def stop(), do: Top.Server.stop

end
