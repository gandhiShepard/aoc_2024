defmodule Aoc.Solutions.Y24.Day04 do
  alias AoC.Input

  @xmas ~w[X M A S]
  @samx ~w[S A M X]

  @mas ~w[M A S]
  @sam ~w[S A M]

  def parse(input, _part) do
    input
    |> Input.stream!()
  end

  def part_one(problem) do
    # This funVjction receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    # [["MMMSXXMASM", "MSAMXMSMSA", "AMXSXMAAMM", "MSAMASMSMX"]]

    four_lines =
      problem
      # |> Enum.take(1)
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.map(fn i ->
        i
        |> Enum.map(fn s ->
          s
          |> String.graphemes()
          |> Enum.with_index(&{&2, &1})
          |> Enum.into(%{})
        end)
        |> Enum.with_index(&{&2, &1})
        |> Enum.into(%{})
      end)
      |> Enum.reduce([], fn group, acc ->
        g =
          for i <- 0..Enum.count(group[0]) do
            [
              vertical?(group, i),
              vertical_reversed?(group, i),
              diagonal_down?(group, i),
              diagonal_down_reversed?(group, i),
              diagonal_up?(group, i),
              diagonal_up_reversed?(group, i)
            ]
          end

        [g | acc]
      end)
      |> List.flatten()
      |> Enum.count(&(&1 == true))

    # |> dbg()

    one_line =
      problem
      # |> Enum.take(1)
      |> Enum.chunk_every(1, 1, :discard)
      |> Enum.map(fn i ->
        i
        |> Enum.map(fn s ->
          s
          |> String.graphemes()
          |> Enum.with_index(&{&2, &1})
          |> Enum.into(%{})
        end)
        |> Enum.with_index(&{&2, &1})
        |> Enum.into(%{})
      end)
      |> Enum.reduce([], fn group, acc ->
        h =
          for i <- 0..Enum.count(group[0]) do
            [
              horizontal?(group, i),
              horizontal_reversed?(group, i)
            ]
          end

        [h | acc]
      end)
      |> List.flatten()
      |> Enum.count(&(&1 == true))

    # |> dbg()

    four_lines + one_line
  end

  def part_two(problem) do
    problem
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn i ->
      i
      |> Enum.map(fn s ->
        s
        |> String.graphemes()
        |> Enum.with_index(&{&2, &1})
        |> Enum.into(%{})
      end)
      |> Enum.with_index(&{&2, &1})
      |> Enum.into(%{})
    end)
    |> Enum.reduce([], fn group, acc ->
      g =
        for i <- 0..Enum.count(group[0]) do
          [
            x_diagonal?(group, i)
          ]
        end

      [g | acc]
    end)
    |> List.flatten()
    |> Enum.count(&(&1 == true))

    # |> dbg()
  end

  # [XMAS______]
  def horizontal?(group, i) do
    @xmas == [group[0][i + 0], group[0][i + 1], group[0][i + 2], group[0][i + 3]]
  end

  # [SAMX______]
  def horizontal_reversed?(group, i) do
    @samx == [group[0][i + 0], group[0][i + 1], group[0][i + 2], group[0][i + 3]]
  end

  # {
  # 	{X________}, [0,{0, X}]
  # 	{M________}, [1,{0, M}]
  # 	{A________}, [2,{0, A}]
  # 	{S________}, [3,{0, S}]
  # }

  def vertical?(group, i) do
    @xmas == [group[0][i], group[1][i], group[2][i], group[3][i]]
  end

  # [
  # 	[S________], [0,{0, S}]
  # 	[A________], [0,{0, A}]
  # 	[M________], [0,{0, M}]
  # 	[X________], [0,{0, X}]
  # ]

  def vertical_reversed?(group, i) do
    @samx == [group[0][i], group[1][i], group[2][i], group[3][i]]
  end

  # [
  # 	[X________], [0,{0, X}]
  # 	[_M_______], [1,{1, M}]
  # 	[__A______], [2,{2, A}]
  # 	[___S_____], [3,{3, S}]
  # ]

  def diagonal_down?(group, i) do
    @xmas == [group[0][0 + i], group[1][1 + i], group[2][2 + i], group[3][3 + i]]
  end

  # [
  # 	[S________], [0,{0, S}]
  # 	[_A_______], [1,{1, A}]
  # 	[__M______], [2,{2, M}]
  # 	[___X_____], [3,{3, X}]
  # ]

  def diagonal_down_reversed?(group, i) do
    @samx == [group[0][0 + i], group[1][1 + i], group[2][2 + i], group[3][3 + i]]
  end

  # [
  # 	[___S_____], [0,{3, S}]
  # 	[__A______], [1,{2, A}]
  # 	[_M_______], [2,{1, M}]
  # 	[X________], [3,{0, X}]
  # ]

  def diagonal_up?(group, i) do
    @xmas == [group[3][0 + i], group[2][1 + i], group[1][2 + i], group[0][3 + i]]
  end

  # [
  # 	[___X_____], [0,{3, X}]
  # 	[__M______], [1,{2, M}]
  # 	[_A_______], [2,{1, A}]
  # 	[S________], [3,{0, S}]
  # ]

  def diagonal_up_reversed?(group, i) do
    @samx == [group[3][0 + i], group[2][1 + i], group[1][2 + i], group[0][3 + i]]
  end

  def x_diagonal?(group, i) do
    (@mas == [group[0][0 + i], group[1][1 + i], group[2][2 + i]] ||
       @sam == [group[0][0 + i], group[1][1 + i], group[2][2 + i]]) &&
      (@mas == [group[2][0 + i], group[1][1 + i], group[0][2 + i]] ||
         @sam == [group[2][0 + i], group[1][1 + i], group[0][2 + i]])
  end
end
