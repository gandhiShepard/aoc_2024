defmodule Aoc.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input)
    |> Stream.reject(fn x -> x == "\n" end)
  end

  def part_one(problem) do
    problem
    |> data_to_rules_and_page_list()
    |> find_ordered_pages()
    |> sum_of_middle_item_in_list()
  end

  def part_two(problem) do
    problem
    |> data_to_rules_and_page_list()
    |> find_unordered_pages()
    |> fix_unordered_pages()
    |> sum_of_middle_item_in_list()
  end

  defp data_to_rules_and_page_list(data) do
    Enum.reduce(data, {%{}, []}, fn
      "", acc ->
        acc

      <<left::binary-size(2), "|", right::binary-size(2), _rest::binary>>, {rules, pages} ->
        {Map.put(rules, [left, right], 0), pages}

      line, {rules, pages} ->
        line_to_list = String.split(line, [",", "\n"] , trim: true)

        {rules, [line_to_list | pages]}
    end)
  end

  defp find_ordered_pages({rules, pages_list}) do
    for pages <- pages_list, Enum.all?(Enum.chunk_every(pages, 2, 1, :discard), fn x -> Map.has_key?(rules, x) end) do
      pages
    end
  end

  defp find_unordered_pages({rules, pages_list}) do
    for pages <- pages_list, !Enum.all?(Enum.chunk_every(pages, 2, 1, :discard), fn x -> Map.has_key?(rules, x) end) do
      {rules, pages}
    end
  end

  defp fix_unordered_pages(unordered_page_list) do
    unordered_page_list
    |> Enum.map(fn {rules, unordered_list} -> fix_list(rules, unordered_list) end)
  end

  defp fix_list(rules, list), do: do_fix(rules, list, [], :ordered)

  defp do_fix(rules, [page], acc, :not_ordered), do: do_fix(rules, Enum.reverse([page | acc]), [], :ordered)
  defp do_fix(_rules, [page], acc, :ordered), do: Enum.reverse([page | acc])

  defp do_fix(rules, [head, next | rest], acc, sort_order) when is_map_key(rules, [head, next]),
    do:  do_fix(rules, [next | rest], [head | acc], sort_order)
  defp do_fix(rules, [head, next | rest], acc, _sort_order), do:  do_fix(rules, [next, head | rest], acc, :not_ordered)

  defp sum_of_middle_item_in_list(pages_list) do
    for pages <- pages_list, reduce: 0 do
      acc ->
        pages
        |> get_middle_item()
        |> String.to_integer()
        |> Kernel.+(acc)
    end
  end

  defp get_middle_item(list) do
    Enum.at(list, div(length(list), 2))
  end
end
