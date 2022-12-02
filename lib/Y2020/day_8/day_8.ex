defmodule Aoc.Y2020.Day8 do
  use Aoc.Day

  answers do
    part_1 1614
    part_2 1260
  end

  input do
    handle_input &String.split(&1, "\n")
  end

  solutions do
    part_1 fn input ->
      input |> execute(0) |> elem(1)
    end

    part_2 fn input ->
      input |> execute(0, true) |> elem(1)
    end
  end

  defp execute(input, i, find_glitch? \\ false, acc \\ 0, run \\ []) do
    if i in run do
      {:infinite, acc}
    else
      case Enum.at(input, i) do
        "nop " <> dest ->
          result = execute(input, i + 1, find_glitch?, acc, [i | run])

          if find_glitch? do
            case result do
              {:infinite, _acc} ->
                execute(input, i + int(dest), false, acc, [i | run])

              {:finite, acc} ->
                {:finite, acc}
            end
          else
            result
          end

        "jmp " <> dest ->
          result = execute(input, i + int(dest), find_glitch?, acc, [i | run])

          if find_glitch? do
            case result do
              {:infinite, _acc} ->
                execute(input, i + 1, false, acc, [i | run])

              {:finite, acc} ->
                {:finite, acc}
            end
          else
            result
          end

        "acc " <> acc_change ->
          execute(input, i + 1, find_glitch?, acc + int(acc_change), [i | run])

        nil ->
          {:finite, acc}
      end
    end
  end

  defp int("-" <> value) do
    -String.to_integer(value)
  end

  defp int("+" <> value) do
    String.to_integer(value)
  end
end
