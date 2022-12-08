defmodule Aoc.Y2022.Day7 do
  use Aoc.Day

  answers do
    part_1 1_844_187
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> parse_commands()
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> follow_instructions()
      |> Map.get("/")
      |> all_directories_and_sizes("/")
      |> Stream.filter(fn {_name, size} ->
        size <= 100_000
      end)
      |> Stream.map(&elem(&1, 1))
      |> Enum.to_list()
      |> Enum.sum()
    end

    part_2 fn input ->
      fs =
        input
        |> follow_instructions()

      sizes = all_directories_and_sizes(fs["/"], "/")

      total_size =
        Enum.find_value(sizes, fn {key, value} ->
          if key == "/" do
            value
          end
        end)

      remaining_space = 70_000_000 - total_size
      need_to_delete = 30_000_000 - remaining_space

      sizes
      |> Stream.map(&elem(&1, 1))
      |> Stream.filter(&(&1 >= need_to_delete))
      |> Enum.min()
    end
  end

  def all_directories_and_sizes(fs, current_key, path \\ "/") do
    {folders, files} = Enum.split_with(fs, fn {_key, value} -> is_map(value) end)

    child_folders =
      Enum.flat_map(folders, fn {key, value} ->
        all_directories_and_sizes(value, Path.join(path, key), Path.join(path, key))
      end)

    folder_sizes =
      child_folders
      |> Enum.filter(fn {child_path, _} -> Path.dirname(child_path) == path end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.sum()

    file_sizes = files |> Enum.map(&elem(&1, 1)) |> Enum.sum()

    [{current_key, folder_sizes + file_sizes} | child_folders]
  end

  defp follow_instructions(instructions, fs \\ %{}, path \\ [])

  defp follow_instructions([], fs, _), do: fs

  defp follow_instructions([{"cd", [".."], _} | rest], fs, current_path) do
    follow_instructions(rest, fs, :lists.droplast(current_path))
  end

  defp follow_instructions([{"cd", [path], _} | rest], fs, current_path) do
    follow_instructions(rest, fs, current_path ++ Path.split(path))
  end

  defp follow_instructions([{"ls", [], output} | rest], fs, current_path) do
    fs =
      Enum.reduce(output, fs, fn
        "dir " <> folder, fs ->
          do_put_in(fs, current_path ++ [folder], %{})

        other, fs ->
          {int, " " <> file} = Integer.parse(other)

          do_put_in(fs, current_path ++ [file], int)
      end)

    follow_instructions(rest, fs, current_path)
  end

  defp parse_commands([]), do: []

  defp parse_commands(["$" <> cmd | rest]) do
    {output, rest} = Enum.split_while(rest, &(!String.starts_with?(&1, "$")))
    [cmd | args] = String.split(cmd, " ", trim: true)
    [{cmd, args, output} | parse_commands(rest)]
  end

  defp do_put_in(map, [key], value) do
    map
    |> Kernel.||(%{})
    |> Map.put(key, value)
  end

  defp do_put_in(map, [item | rest], value) do
    map
    |> Kernel.||(%{})
    |> Map.put_new(item, nil)
    |> Map.update!(item, &do_put_in(&1, rest, value))
  end
end
