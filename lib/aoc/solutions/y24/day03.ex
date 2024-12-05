defmodule Aoc.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
  end

  def part_one(problem) do
    problem
    |> do_parse([])
  end

  def part_two(problem) do
    problem
    |> do_parse2(:on, [])
  end

  # xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

  defp do_parse("", acc), do: Enum.sum(acc)

  defp do_parse(<<"mul(", a, b, c, ",", x, y, z, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9 and y in ?0..?9 and
              z in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>)
           | acc
         ])

  defp do_parse(<<"mul(", a, b, c, ",", x, y, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>> <> <<y>>) | acc
         ])

  defp do_parse(<<"mul(", a, b, c, ",", x, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>>) | acc
         ])

  defp do_parse(<<"mul(", a, b, ",", x, y, z, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9 and y in ?0..?9 and z in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>) | acc
         ])

  defp do_parse(<<"mul(", a, ",", x, y, z, ")", rest::binary>>, acc)
       when a in ?0..?9 and x in ?0..?9 and y in ?0..?9 and z in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>) | acc
         ])

  defp do_parse(<<"mul(", a, b, ",", x, y, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do:
         do_parse(rest, [
           String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>> <> <<y>>) | acc
         ])

  defp do_parse(<<"mul(", a, b, ",", x, ")", rest::binary>>, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9,
       do: do_parse(rest, [String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>>) | acc])

  defp do_parse(<<"mul(", a, ",", x, y, ")", rest::binary>>, acc)
       when a in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do: do_parse(rest, [String.to_integer(<<a>>) * String.to_integer(<<x>> <> <<y>>) | acc])

  defp do_parse(<<"mul(", a, ",", x, ")", rest::binary>>, acc) when a in ?0..?9 and x in ?0..?9,
    do: do_parse(rest, [String.to_integer(<<a>>) * String.to_integer(<<x>>) | acc])

  defp do_parse(<<_c, rest::binary>>, acc), do: do_parse(rest, acc)

  defp do_parse2("", _status, acc), do: Enum.sum(acc)

  defp do_parse2("don't()" <> rest, :on, acc), do: do_parse2(rest, :off, acc)
  defp do_parse2("don't()" <> rest, :off, acc), do: do_parse2(rest, :off, acc)

  defp do_parse2("do()" <> rest, :off, acc), do: do_parse2(rest, :on, acc)
  defp do_parse2("do()" <> rest, :on, acc), do: do_parse2(rest, :on, acc)

  defp do_parse2(<<"mul(", a, b, c, ",", x, y, z, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9 and y in ?0..?9 and
              z in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>)
           | acc
         ])

  defp do_parse2(<<"mul(", a, b, c, ",", x, y, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>> <> <<y>>) | acc
         ])

  defp do_parse2(<<"mul(", a, b, c, ",", x, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and c in ?0..?9 and x in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>> <> <<b>> <> <<c>>) * String.to_integer(<<x>>) | acc
         ])

  defp do_parse2(<<"mul(", a, b, ",", x, y, z, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9 and y in ?0..?9 and z in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>) | acc
         ])

  defp do_parse2(<<"mul(", a, ",", x, y, z, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and x in ?0..?9 and y in ?0..?9 and z in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>>) * String.to_integer(<<x>> <> <<y>> <> <<z>>) | acc
         ])

  defp do_parse2(<<"mul(", a, b, ",", x, y, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do:
         do_parse2(rest, :on, [
           String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>> <> <<y>>) | acc
         ])

  defp do_parse2(<<"mul(", a, b, ",", x, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and b in ?0..?9 and x in ?0..?9,
       do:
         do_parse2(rest, :on, [String.to_integer(<<a>> <> <<b>>) * String.to_integer(<<x>>) | acc])

  defp do_parse2(<<"mul(", a, ",", x, y, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and x in ?0..?9 and y in ?0..?9,
       do:
         do_parse2(rest, :on, [String.to_integer(<<a>>) * String.to_integer(<<x>> <> <<y>>) | acc])

  defp do_parse2(<<"mul(", a, ",", x, ")", rest::binary>>, :on, acc)
       when a in ?0..?9 and x in ?0..?9,
       do: do_parse2(rest, :on, [String.to_integer(<<a>>) * String.to_integer(<<x>>) | acc])

  defp do_parse2(<<_c, rest::binary>>, status, acc), do: do_parse2(rest, status, acc)
end
