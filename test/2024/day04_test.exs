defmodule Aoc.Solutions.Y24.Day04Test do
  alias AoC.Input, warn: false
  alias Aoc.Solutions.Y24.Day04, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2024 --day 4
  #
  #     mix test test/2024/day04_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2024 --day 4 --part 1
  #
  # Use sample input file:
  #
  #     # returns {:ok, "priv/input/2024/day-04-mysuffix.inp"}
  #     {:ok, path} = Input.resolve(2024, 4, "mysuffix")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    assert solve(input, :part_one) == 18
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 2532
  #
  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 4, :part_one)
  end

  test "part two example" do
    input = ~S"""
    .M.S......
    ..A..MSMS.
    .M.S.MAA..
    ..A.ASMSM.
    .M.S.M....
    ..........
    S.S.S.S.S.
    .A.A.A.A..
    M.M.M.M.M.
    ..........
    """

    assert solve(input, :part_two) == 9
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 1941
  #
  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 4, :part_two)
  end
end
