defmodule Aoc.Solutions.Y24.Day06 do
  alias AoC.Input

  @obstacle "#"
  @guard "^"

  def parse(input, _part) do
    input
    |> Input.stream!()
    |> Stream.map(fn x -> String.trim(x) end)
    |> Stream.with_index(&{&2, &1})
  end

  def part_one(problem) do
    map = generate_lab_map(problem)
    [guard_position] = find_guard(map)

    navigate(map, :north, guard_position, %{guard_position => 1})
    |> map_size()
    # |> dbg()
  end

  # def part_two(problem) do
  # end

  defp navigate(map, :north, current_position, acc) do
    case try_north(map, current_position) do
      {nil, _, _} -> acc
      {@obstacle, _new_col, _new_row} -> navigate(map, :east, current_position, acc)
      new_position -> navigate(map, :north, new_position, update(acc, new_position))
    end
  end

  defp navigate(map, :east, current_position, acc) do
    case try_east(map, current_position) do
      {nil, _, _} -> acc
      {@obstacle, _new_col, _new_row} -> navigate(map, :south, current_position, acc)
      new_position -> navigate(map, :east, new_position, update(acc, new_position))
    end
  end

  defp navigate(map, :south, current_position, acc) do
    case try_south(map, current_position) do
      {nil, _, _} -> acc
      {@obstacle, _new_col, _new_row} -> navigate(map, :west, current_position, acc)
      new_position -> navigate(map, :south, new_position, update(acc, new_position))
    end
  end

  defp navigate(map, :west, current_position, acc) do
    case try_west(map, current_position) do
      {nil, _, _} -> acc
      {@obstacle, _new_col, _new_row} -> navigate(map, :north, current_position, acc)
      new_position -> navigate(map, :west, new_position, update(acc, new_position))
    end
  end

  defp try_north(map, {_, col, row}), do: {map[col - 1][row], col - 1, row}
  defp try_east(map, {_, col, row}), do: {map[col][row + 1], col, row + 1}
  defp try_south(map, {_, col, row}), do: {map[col + 1][row], col + 1, row}
  defp try_west(map, {_, col, row}), do: {map[col][row - 1], col, row - 1}

  defp update(acc, new_position),
    do: Map.update(acc, new_position, 1, & &1 + 1)

  defp generate_lab_map(string_list) do
    Enum.reduce(string_list, %{}, fn
      {_index, ""}, acc -> acc

      {index, string}, acc ->
        string_to_map =
          string
          |> String.graphemes()
          |> Enum.with_index(& {&2, &1})
          |> Enum.into(%{})

        Map.put(acc, index, string_to_map)
    end)
  end

  defp find_guard(map) do
    for {col, col_val} <- map,
        {row, _row_val} <- col_val, col_val[row] == @guard,
    do: {@guard, col, row}
  end
end
