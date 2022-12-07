defmodule Aoc.Report do
  @total_stars 400

  def yearly_report do
    years =
      :aoc
      |> Spark.sparks(Aoc.Day)
      |> Enum.map(fn spark ->
        [_, "Y" <> year, "Day" <> day] = Module.split(spark)

        %{day: spark, year: String.to_integer(year), day_number: String.to_integer(day)}
      end)
      |> Enum.group_by(& &1.year)
      |> Enum.sort_by(&elem(&1, 1))
      |> Enum.map(fn {year, days} ->
        stars =
          days
          |> Enum.sort_by(& &1.day_number)
          |> Enum.map(fn %{day: day, day_number: day_number} ->
            stars =
              if Aoc.Day.Info.part_1_answer(day) do
                1
              else
                0
              end

            if (day_number == 25 && stars == 1) || Aoc.Day.Info.part_2_answer(day) do
              stars + 1
            else
              stars
            end
          end)
          |> Enum.sum()

        %{year: year, stars: stars}
      end)

    Enum.map_join(years, "\n---\n", fn %{year: year, stars: stars} ->
      "Year #{year}: #{stars}/50"
    end)
    |> Kernel.<>("\n\nTotal: #{years |> Enum.map(& &1.stars) |> Enum.sum()}/#{@total_stars}")
  end

  def daily_report do
    :aoc
    |> Spark.sparks(Aoc.Day)
    |> Enum.map(fn spark ->
      [_, "Y" <> year, "Day" <> day] = Module.split(spark)

      %{day: spark, year: String.to_integer(year), day_number: String.to_integer(day)}
    end)
    |> Enum.group_by(& &1.year)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.map_join("\n---\n", fn {year, days} ->
      star = "⭐️"

      days =
        days
        |> Enum.sort_by(& &1.day_number)
        |> Enum.map_join("\n", fn %{day: day, day_number: day_number} ->
          stars =
            if Aoc.Day.Info.part_1_answer(day) do
              1
            else
              0
            end

          stars =
            if (day_number == 25 && stars == 1) || Aoc.Day.Info.part_2_answer(day) do
              stars + 1
            else
              stars
            end

          "  Day #{String.pad_trailing(to_string(day_number), 2)}: #{String.duplicate(star, stars)}"
        end)

      "Year #{year}\n\n#{days}"
    end)
  end
end
