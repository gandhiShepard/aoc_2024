defmodule Aoc.Solutions.Y24.Day02 do
  @moduledoc false

  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> Enum.map(fn x -> Enum.map(x, fn y -> String.to_integer(y) end) end)
  end

  def part_one(problem) do
    problem
    |> Enum.reduce(0, fn
      x, acc -> if safe?(x) == :safe, do: acc + 1, else: acc
    end)
  end

  defp safe?(list), do: do_safe(list, nil, :safe)

  defp do_safe([_], _x, acc), do: acc
  defp do_safe([], :nope, :unsafe), do: :unsafe

  defp do_safe([a, b | t], nil, :safe) when (a - b) in 1..3, do: do_safe([b | t], :dec, :safe)

  defp do_safe([a, b | t], nil, :safe) when (a - b) in -1..-3//-1,
    do: do_safe([b | t], :inc, :safe)

  defp do_safe([a, b | t], :dec, :safe) when (a - b) in 1..3, do: do_safe([b | t], :dec, :safe)

  defp do_safe([a, b | t], :inc, :safe) when (a - b) in -1..-3//-1,
    do: do_safe([b | t], :inc, :safe)

  defp do_safe([a, b | _t], :dec, :safe) when (a - b) in -1..-3//-1,
    do: do_safe([], :nope, :unsafe)

  defp do_safe([a, b | _t], :inc, :safe) when (a - b) in 1..3, do: do_safe([], :nope, :unsafe)

  defp do_safe(_, _, _), do: do_safe([], :nope, :unsafe)

  # [[7, 6, 4, 2, 1], [1, 2, 7, 8, 9], [9, 7, 6, 2, 1], [1, 3, 2, 4, 5], [8, 6, 4, 4, 1], [1, 3, 6, 7, 9]]

  # [["7", "6", "4", "2", "1"], ["1", "2", "7", "8", "9"], ["9", "7", "6", "2", "1"], ["1", "3", "2", "4", "5"], ["8", "6", "4", "4", "1"], ["1", "3", "6", "7", "9"], [""]]

  def part_two(problem) do
    problem
    |> Enum.map(fn x -> Enum.with_index(x) end)
    |> Enum.reduce(0, fn
      x, acc ->
        z =
          for {v, i} <- x do
            for _j <- x -- [{v, i}], new = x -- [{v, i}], reduce: 0 do
              acc ->
                # IO.inspect(new, label: "new_list")
                case safe?(Enum.map(new, fn {a, _b} -> a end)) do
                  :unsafe -> acc
                  :safe -> acc + 1
                end
            end
          end

        if Enum.sum(z) == 0, do: acc, else: acc + 1
    end)

    # |> Enum.reduce(0, fn x, acc -> if Enum.sum(x) == 0, do: acc, else: acc + 1 end)
    # |> Enum.reduce([], fn x, acc -> [(for i <- x, do: (for _j <- x -- [i], new = x -- [i], do: safe?(new))) | acc] end)
    # |> Enum.redcue(0, fn x, acc ->
    #   case Enum.any?(x -> )
    # end)
  end
end
