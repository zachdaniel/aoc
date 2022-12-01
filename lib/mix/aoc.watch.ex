defmodule Mix.Tasks.Aoc.Watch do
  use Mix.Task

  alias Aoc.Day.Watcher

  def run(_args) do
    :ok = Application.ensure_started(:file_system)
    Watcher.start()
    Mix.shell().info("Making a list, checking it twice...")
    prompt_loop()
  end

  defp prompt_loop() do
    answer = Mix.shell().prompt(": ")

    case Watcher.handle_answer(answer) do
      :quit ->
        :ok

      :continue ->
        prompt_loop()
    end
  end
end
