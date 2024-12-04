defmodule Aoc.Solutions.Y24.Day01 do
  @moduledoc false

  # alias AoC.Input

  def parse(input, _part) do
    # This function will receive the input path or an %AoC.Input.TestInput{}
    # struct. To support the test you may read both types of input with either:
    #
    # * Input.stream!(input), equivalent to File.stream!/1
    # * Input.stream!(input, trim: true), equivalent to File.stream!/2
    # * Input.read!(input), equivalent to File.read!/1
    #
    # The role of your parse/2 function is to return a "problem" for the solve/2
    # function.
    #
    # For instance:
    #
    # input
    # |> Input.stream!()
    # |> Enum.map!(&my_parse_line_function/1)

    input
    |> AoC.Input.read!()
    |> do_parse([], [])
  end

  # def parse(input), do: do_parse(input, [], [])

  defp do_parse("", left, right), do: {left, right}

  defp do_parse(<<l::binary-size(5), "   ", r::binary-size(5), "\n", rest::binary>>, left, right),
    do: do_parse(rest, [String.to_integer(l) | left], [String.to_integer(r) | right])

  def part_one(input) do
    input
    |> then(fn {left, right} -> {Enum.sort(left), Enum.sort(right)} end)
    |> then(fn {left, right} -> Enum.zip(left, right) end)
    |> Enum.reduce(0, fn {l, r}, acc -> abs(l - r) + acc end)
  end

  def part_two(input) do
    input
    |> then(fn {left, right} ->
      {left, Enum.reduce(right, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)}
    end)
    |> then(fn {left, right} ->
      Enum.reduce(left, 0, fn x, acc -> x * Map.get(right, x, 0) + acc end)
    end)
  end
end
