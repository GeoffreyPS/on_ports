defmodule Top do
  @moduledoc """
  Documentation for Top.
  """
  def report(), do: Top.Server.report()

  def report(key), do: Top.Server.report(key)

  def stop(), do: Top.Server.stop
end
