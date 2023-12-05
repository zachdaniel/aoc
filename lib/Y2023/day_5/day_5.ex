defmodule Aoc.Y2023.Day5 do
  use Aoc.Day

  answers do
    part_1 993_500_720
    part_2 4_917_124
  end

  input do
    use_example? false

    handle_input fn input ->
      ["seeds: " <> seeds, maps] =
        input
        |> String.split("\n", parts: 2)

      [
        seed_to_soil,
        soil_to_fertilizer,
        fertilizer_to_water,
        water_to_light,
        light_to_temperature,
        temperature_to_humidity,
        humidity_to_location
      ] =
        maps
        |> String.split(~r/\n.*:/, trim: true)
        |> Enum.map(fn string ->
          string
          |> String.trim()
          |> String.split("\n")
          |> Enum.map(fn range ->
            [dest_start, source_start, range] =
              range
              |> String.split(" ")
              |> Enum.map(&String.to_integer/1)

            %{source_start: source_start, dest_start: dest_start, range: range}
          end)
        end)

      %{
        seeds: seeds |> String.split(" ") |> Enum.map(&String.to_integer/1),
        seed_to_soil: seed_to_soil,
        soil_to_fertilizer: soil_to_fertilizer,
        fertilizer_to_water: fertilizer_to_water,
        water_to_light: water_to_light,
        light_to_temperature: light_to_temperature,
        temperature_to_humidity: temperature_to_humidity,
        humidity_to_location: humidity_to_location
      }
    end
  end

  solutions do
    part_1 fn input ->
      input.seeds
      |> Enum.sort()
      |> Enum.map(&location(input, &1))
      |> Enum.min()
    end

    part_2 fn input ->
      seeds =
        input.seeds
        |> Enum.chunk_every(2)
        |> Enum.map(fn [start, range] ->
          start..(start + (range - 1))
        end)
        |> Enum.uniq()

      Stream.iterate(0, &(&1 + 1))
      |> Enum.find(fn location ->
        seed = seed(input, location)

        Enum.any?(seeds, fn range ->
          seed in range
        end)
      end)
    end
  end

  defp location(input, seed) do
    seed
    |> convert(input, :seed_to_soil)
    |> convert(input, :soil_to_fertilizer)
    |> convert(input, :fertilizer_to_water)
    |> convert(input, :water_to_light)
    |> convert(input, :light_to_temperature)
    |> convert(input, :temperature_to_humidity)
    |> convert(input, :humidity_to_location)
  end

  defp seed(input, location) do
    location
    |> convert(input, :humidity_to_location, true)
    |> convert(input, :temperature_to_humidity, true)
    |> convert(input, :light_to_temperature, true)
    |> convert(input, :water_to_light, true)
    |> convert(input, :fertilizer_to_water, true)
    |> convert(input, :soil_to_fertilizer, true)
    |> convert(input, :seed_to_soil, true)
  end

  defp convert(number, input, key, reverse? \\ false) do
    input
    |> Map.get(key)
    |> Enum.find_value(fn range_data ->
      if reverse? do
        if number in range_data.dest_start..(range_data.dest_start + range_data.range - 1) do
          range_data.source_start + (number - range_data.dest_start)
        end
      else
        if number in range_data.source_start..(range_data.source_start + range_data.range - 1) do
          range_data.dest_start + (number - range_data.source_start)
        end
      end
    end)
    |> case do
      nil ->
        number

      converted ->
        converted
    end
  end
end
