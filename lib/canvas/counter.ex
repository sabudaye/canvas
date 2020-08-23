defmodule Canvas.Counter do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 1 end, name: __MODULE__)
  end

  def next do
    Agent.get_and_update(__MODULE__, fn state -> {state, state + 1} end)
  end
end
