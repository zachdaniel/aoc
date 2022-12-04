defmodule Aoc.Y2021.Day20 do
  use Aoc.Day

  answers do
    part_1 5275
    part_2 16482
  end

  input do
    handle_input fn input ->
      [image_enhancer, input_image] = String.split(input, "\n\n", trim: true)

      input_image = parse_input_image(input_image)
      image_enhancer = parse_image_enhancer(image_enhancer)

      %{
        image_enhancer: image_enhancer,
        image: input_image,
        image_enhancer_lights_infinity?: 0 in image_enhancer,
        image_enhancer_turns_off_infinity?: 511 not in image_enhancer,
        infinity_is_lit?: false,
        bounds: bounds(input_image)
      }
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> enhance(2)
      |> Map.get(:image)
      |> Enum.count()
    end

    part_2 fn input ->
      input
      |> enhance(50)
      |> Map.get(:image)
      |> Enum.count()
    end
  end

  defp bounds(input_image) do
    ys = Enum.map(input_image, &elem(&1, 1))
    xs = Enum.map(input_image, &elem(&1, 0))

    {(Enum.min(xs) - 1)..(Enum.max(xs) + 1), (Enum.min(ys) - 1)..(Enum.max(ys) + 1)}
  end

  defp parse_image_enhancer(image_enhancer) do
    image_enhancer
    |> String.split("\n")
    |> Enum.join()
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn
      {"#", index}, map_set ->
        MapSet.put(map_set, index)

      _, map_set ->
        map_set
    end)
  end

  def parse_input_image(input_image) do
    input_image
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, y}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {"#", x}, acc ->
          MapSet.put(acc, {x, y})

        _, acc ->
          acc
      end)
    end)
  end

  defp enhance(input, 0), do: input

  defp enhance(input, times) do
    input
    |> enhance_once()
    |> enhance(times - 1)
  end

  defp enhance_once(%{bounds: {x_bounds, y_bounds}} = input) do
    new_image =
      y_bounds
      |> Enum.reduce(MapSet.new(), fn y, image ->
        x_bounds
        |> Enum.reduce(image, fn x, image ->
          if lit_in_output_image?({x, y}, input) do
            MapSet.put(image, {x, y})
          else
            image
          end
        end)
      end)

    %{
      input
      | image: new_image
    }
    |> figure_out_infinity()
    |> expand_bounds(2)
  end

  defp expand_bounds(
         %{bounds: {x_bounds, y_bounds}, infinity_is_lit?: infinity_is_lit?, image: image} =
           input,
         n
       ) do
    new_x_bounds = (x_bounds.first - n)..(x_bounds.last + n)
    new_y_bounds = (y_bounds.first - n)..(y_bounds.last + n)

    new_image =
      if infinity_is_lit? do
        x_coordinates =
          (x_bounds.first - n)..(x_bounds.first - 1)
          |> Enum.concat((x_bounds.last + 1)..(x_bounds.last + n))

        new_image =
          Enum.reduce(x_coordinates, image, fn x, image ->
            Enum.reduce(new_y_bounds, image, fn y, image ->
              MapSet.put(image, {x, y})
            end)
          end)

        y_coordinates =
          (y_bounds.first - n)..(y_bounds.first - 1)
          |> Enum.concat((y_bounds.last + 1)..(y_bounds.last + n))

        Enum.reduce(new_x_bounds, new_image, fn x, image ->
          Enum.reduce(y_coordinates, image, fn y, image ->
            MapSet.put(image, {x, y})
          end)
        end)
      else
        image
      end

    %{
      input
      | bounds: {new_x_bounds, new_y_bounds},
        image: new_image
    }
  end

  defp figure_out_infinity(
         %{infinity_is_lit?: false, image_enhancer_lights_infinity?: true} = input
       ) do
    %{input | infinity_is_lit?: true}
  end

  defp figure_out_infinity(
         %{infinity_is_lit?: true, image_enhancer_turns_off_infinity?: true} = input
       ) do
    %{input | infinity_is_lit?: false}
  end

  defp figure_out_infinity(input), do: input

  defp lit_in_output_image?({x, y}, %{
         image: image,
         image_enhancer: image_enhancer,
         bounds: bounds,
         infinity_is_lit?: infinity_is_lit?
       }) do
    number = get_binary_number({x, y}, image, bounds, infinity_is_lit?)
    number in image_enhancer
  end

  def get_binary_number({x, y}, image, bounds, infinity_is_lit?) do
    {x, y}
    |> input_pixels()
    |> Enum.map_join("", fn pixel ->
      cond do
        pixel in image ->
          "1"

        pixel_out_of_bounds?(pixel, bounds) && infinity_is_lit? ->
          "1"

        true ->
          "0"
      end
    end)
    |> String.to_integer(2)
  end

  defp pixel_out_of_bounds?({x, y}, {x_bounds, y_bounds}) do
    x not in x_bounds || y not in y_bounds
  end

  defp input_pixels({x, y}) do
    [
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x - 1, y},
      {x, y},
      {x + 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ]
  end

  # defp print(%{bounds: {x_bounds, y_bounds}, image: image} = input) do
  #   y_bounds
  #   |> Enum.reverse()
  #   |> Enum.map_join("\n", fn y ->
  #     Enum.map_join(x_bounds, "", fn x ->
  #       if {x, y} in image do
  #         "#"
  #       else
  #         "."
  #       end
  #     end)
  #   end)
  #   |> IO.puts()

  #   input
  # end
end
