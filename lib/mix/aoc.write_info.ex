defmodule Mix.Tasks.Aoc.WriteInfo do
  use Mix.Task

  def run(args, started? \\ false)

  def run([year, day], started?) do
    unless started?, do: start_agent()
    year = String.to_integer(year)
    day = String.to_integer(day)

    module = Module.concat(["Aoc", "Y#{year}", "Day#{day}"])
    Code.ensure_compiled!(module)

    stars = Enum.count([Aoc.Day.Info.part_1_answer(module), Aoc.Day.Info.part_2_answer(module)])

    update_day(year, day, fn day_data ->
      Map.put(day_data, "stars", stars)
    end)

    unless started? do
      write_files!()
    end
  end

  def run(["--all"], _) do
    start_agent()

    "lib/Y*"
    |> Path.wildcard()
    |> Enum.map(&String.trim_leading(&1, "lib/Y"))
    |> Enum.flat_map(fn year ->
      "lib/Y#{year}/day_*"
      |> Path.wildcard()
      |> Enum.map(&String.trim_leading(&1, "lib/Y#{year}/day_"))
      |> Enum.map(fn day ->
        [year, day]
      end)
    end)
    |> Task.async_stream(&run(&1, true))
    |> Stream.run()

    write_files!()
  end

  def run(args, _) do
    raise "Expected to get either --all or a year and a day as arguments. Got #{inspect(args)}"
  end

  defp write_files!() do
    data =
      "lib/data.json"
      |> File.read!()
      |> Jason.decode!()
      |> Map.new(fn {year, year_data} ->
        {String.to_integer(year),
         Map.new(year_data, fn {day, day_data} ->
           {String.to_integer(day), day_data}
         end)}
      end)

    stars_by_year =
      data
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map(fn {year, days} ->
        star_count =
          days
          |> Enum.map(fn {_, %{"stars" => stars}} -> stars end)
          |> Enum.sum()

        color =
          if star_count == 50 do
            "green"
          else
            "orange"
          end

        {year, star_count, color}
      end)

    assigns = [
      stars_by_year: stars_by_year
    ]

    Mix.Generator.copy_template("lib/templates/README.md.eex", "README.md", assigns, force: true)
  end

  defp update_day(year, day, func) do
    Agent.get(WriteInfo, fn nil ->
      contents =
        "lib/data.json"
        |> File.read!()
        |> Jason.decode!()
        |> Map.put_new(to_string(year), %{})
        |> Map.update!(to_string(year), fn year_data ->
          year_data
          |> Map.put_new(to_string(day), %{})
          |> Map.update!(to_string(day), func)
        end)
        |> Jason.encode!(pretty: true)

      File.write!("lib/data.json", contents)
    end)
  end

  defp start_agent() do
    # if its already started thats fine
    {:ok, _} = Agent.start_link(fn -> nil end, name: WriteInfo)
  end
end
