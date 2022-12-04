defmodule Mix.Tasks.Aoc.Gen.Day do
  use Mix.Task

  alias Aoc.Day.Watcher

  def run([year, day]) do
    year = String.to_integer(year)
    day = String.to_integer(day)
    folder = "lib/Y#{year}/day_#{day}"

    File.mkdir_p!(folder)

    folder
    |> Path.join("input.txt")
    |> File.touch!()

    folder
    |> Path.join("example_input.txt")
    |> File.touch!()

    folder
    |> Path.join("day_#{day}.ex")
    |> File.write!("""
    defmodule Aoc.Y#{year}.Day#{day} do
      use Aoc.Day

      answers do
      end

      input do
        use_example? true

        handle_input fn input ->
          input
        end
      end

      solutions do
        part_1 fn input ->
          input
        end

        part_2 fn input ->
          input
        end
      end
    end
    """)
  end
end
