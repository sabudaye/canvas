defmodule Canvas.Storage do
  use Agent

  def start_link(matrix, name) do
    Agent.start_link(fn -> matrix end, name: name)
  end

  def value(pid) do
    Agent.get(pid, & &1)
  end

  def update(pid, new_matrix) do
    Agent.update(pid, fn _ -> new_matrix end)
  end
end
