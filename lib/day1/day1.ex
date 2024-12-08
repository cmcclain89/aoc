defmodule Day1 do
  @moduledoc """
  AoC day1
  """

  alias Day1Data

  def run do
    Day1Data.example()
    |> Enum.reduce({[], []}, fn {first, second}, {first_acc, second_acc} ->
      {[first | first_acc], [second | second_acc]}
    end)
    |> then(fn hmm ->
      {first, second} = hmm
      first = Enum.sort(first)

      second =
        Enum.sort(second)
        |> Enum.with_index()
        |> Map.new(fn {value, idx} -> {idx, value} end)

      {result, _} =
        Enum.reduce(first, {0, 0}, fn value, {diff, idx} ->
          {abs(value - second[idx]) + diff, idx + 1}
        end)

      result
    end)
  end

  def run_part2 do
    Day1Data.example()
    |> Enum.reduce({[], []}, fn {first, second}, {first_acc, second_acc} ->
      {[first | first_acc], [second | second_acc]}
    end)
    |> then(fn hmm ->
      {first, second} = hmm
      first = Enum.sort(first)

      second =
        Enum.reduce(second, %{}, fn value, acc ->
          Map.update(acc, value, 1, fn x -> x + 1 end)
        end)

      Enum.reduce(first, 0, fn value, acc ->
        value * Map.get(second, value, 0) + acc
      end)
    end)
  end
end
