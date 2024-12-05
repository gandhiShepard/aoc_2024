defmodule Aoc.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input)
    |> Stream.reject(fn x -> x == "\n" end)
  end

  def part_one(problem) do
    problem
    |> format_data()
    |> sum_of_middle_pages_in_correct_order()
    # |> dbg()
  end

  def part_two(problem) do
    problem
    |> format_data()
    |> find_unordered_pages()
    |> fix_unordered_pages()
    |> Enum.reduce(0, fn x, acc -> String.to_integer(x) + acc end)
  end

  # [{["97|13", "13|75", "75|29", "29|47"], "75"}, {["61|13", "13|29"], "13"}, {["75|97", "97|47", "47|61", "61|53"], "47"}]

  # [{[["97", "13"], ["13", "75"], ["75", "29"], ["29", "47"]], "75", ["97", "13", "75", "29", "47"]}, {[["61", "13"], ["13", "29"]], "13", ["61", "13", "29"]}, {[["75", "97"], ["97", "47"], ["47", "61"], ["61", "53"]], "47", ["75", "97", "47", "61", "53"]}]

  defp fix_unordered_pages({rules, unordered_page_list}) do
    unordered_page_list
    |> Enum.map(fn unordered_list -> fix_list(rules, unordered_list) end)
  end

  defp fix_list(rules, list), do: do_fix(rules, list, [], :ordered)

  defp do_fix(rules, [page], acc, :not_ordered), do: do_fix(rules, Enum.reverse([page | acc]), [], :ordered)
  defp do_fix(_rules, [page], acc, :ordered), do: get_middle_item([page | acc])
  # defp do_fix(_rules, [page], acc, :ordered), do: Enum.reverse([page | acc])

  defp do_fix(rules, [head, next | rest], acc, sort_order) when is_map_key(rules, [head, next]),
    do:  do_fix(rules, [next | rest], [head | acc], sort_order)
  defp do_fix(rules, [head, next | rest], acc, _sort_order), do:  do_fix(rules, [next, head | rest], acc, :not_ordered)


  defp find_unordered_pages({rules, pages}) do
    list = for {page_list, _middle_page, original_list} <- pages, !Enum.all?(page_list, fn x -> Map.has_key?(rules, x) end) do
      original_list
    end

    {rules, list}
  end

  defp sum_of_middle_pages_in_correct_order({rules, pages}) do
    for {page_list, middle_page, _original_list} <- pages, reduce: 0 do
      acc ->
        case Enum.all?(page_list, fn x -> Map.has_key?(rules, x) end) do
          true -> String.to_integer(middle_page) + acc
          false -> acc
        end
    end
  end

  defp format_data(data) do
    Enum.reduce(data, {%{}, []}, fn
      "", acc ->
        acc

      <<left::binary-size(2), "|", right::binary-size(2), _rest::binary>>, {rules, pages} ->
        {Map.put(rules, [left, right], 0), pages}

      line, {rules, pages} ->
        line_to_list = String.split(line, [",", "\n"] , trim: true)

        page_format =
          line_to_list
          |> Enum.chunk_every(2, 1, :discard)
          # |> Enum.map(&Enum.join(&1, "|"))

        middle_page =
          get_middle_item(line_to_list)
          # Enum.at(line_to_list, div(length(line_to_list), 2))

        {rules, [{page_format, middle_page, line_to_list} | pages]}
    end)
  end

  defp get_middle_item(list) do
    Enum.at(list, div(length(list), 2))
  end
end
