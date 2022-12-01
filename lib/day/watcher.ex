defmodule Aoc.Day.Watcher do
  use GenServer

  @file_change_debounce_ms 200
  @restart_task_threshold_ms 1000

  def start(shell \\ Mix.shell()) do
    GenServer.start_link(__MODULE__, %{state: :base, shell: shell, tasks: %{}}, name: __MODULE__)
  end

  def init(state) do
    opts = [dirs: [Path.absname("lib")], name: :aoc_watcher]

    case FileSystem.start_link(opts) do
      {:ok, _} ->
        FileSystem.subscribe(:aoc_watcher)
        {:ok, []}

      other ->
        raise "Could not start watcher"

        other
    end

    {:ok, state}
  end

  def handle_answer(answer) do
    GenServer.call(
      __MODULE__,
      {:handle_answer, answer |> String.trim_trailing("\n") |> String.trim_leading(" ")},
      :infinity
    )
  end

  def handle_info({task, result}, state) do
    {path, %{day: day}} =
      Enum.find(state.tasks, fn
        {_, %{task: %{ref: ^task}}} ->
          true

        _ ->
          false
      end)

    state =
      Map.update!(state, :tasks, fn tasks ->
        Map.delete(tasks, path)
      end)

    case result do
      {:ok, {answer_for, result}} ->
        state.shell.info("Answer for #{inspect(day)}.#{answer_for} is #{inspect(result)}")

      {:error, error, stack} ->
        state.shell.info(
          "Error getting answer for #{inspect(day)}\n#{Exception.format(:error, error, stack)}"
        )

        {:error, error}
    end

    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, _, :normal}, state) do
    {:noreply, state}
  end

  def handle_info({:file_event, _, {path, _events}}, state) do
    wait_for_file_to_stop_changing(path)

    case get_day(path) do
      nil ->
        {:noreply, state}

      day ->
        now = System.monotonic_time(:millisecond)

        should_start? =
          case Map.get(state.tasks, path) do
            nil ->
              true

            %{task: task, started: started} ->
              if now - started <= @restart_task_threshold_ms do
                false
              else
                Task.shutdown(task)
                true
              end
          end

        if should_start? do
          state.shell.info("Computing answer for #{inspect(day)}")

          IEx.Helpers.r(day)

          task =
            Task.async(fn ->
              try do
                {:ok, Aoc.Day.compute_missing_answer(day)}
              rescue
                e ->
                  {:error, e, __STACKTRACE__}
              end
            end)

          {:noreply,
           %{state | tasks: Map.put(state.tasks, path, %{task: task, started: now, day: day})}}
        else
          state.shell.info("#{inspect(day)} just changed, not restarting task")
          {:noreply, state}
        end
    end
  end

  def handle_call({:handle_answer, "q"}, _, %{state: :base} = state), do: {:reply, :quit, state}

  def handle_call({:handle_answer, other}, _, state) do
    state.shell.info("Unknown command: #{other}.")
    {:reply, :continue, state}
  end

  defp wait_for_file_to_stop_changing(path) do
    # this is only kind of a debounce
    receive do
      {:file_event, _, {^path, _events}} ->
        wait_for_file_to_stop_changing(path)
    after
      @file_change_debounce_ms ->
        :ok
    end
  end

  defp get_day(path) do
    :aoc
    |> Spark.sparks(Aoc.Day)
    |> Enum.find(fn day ->
      to_string(day.module_info()[:compile][:source]) == path
    end)
  end
end
