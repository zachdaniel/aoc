defmodule Aoc.Day.Watcher do
  use GenServer

  def start(shell) do
    GenServer.start_link(__MODULE__, %{state: :base, shell: shell}, name: __MODULE__)
  end

  def init(state) do
    state
  end

  def handle_answer(answer) do
    GenServer.call(__MODULE__, {:handle_answer, answer}, :infinity)
  end

  def handle_call({:handle_answer, "q"}, _, %{state: :base} = state), do: {:reply, :quit, state}

  def handle_call({:handle_answer, other}, _, state) do
    state.shell.info("Unknown command: #{other}.")
    {:reply, :continue, state}
  end
end
