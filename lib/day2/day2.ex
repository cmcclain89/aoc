defmodule Day2 do
  @moduledoc """
  AoC day2
  """

  def run do
    {safe, _unsafe} =
      Path.join([:code.priv_dir(:aoc), "day2_data.txt"])
      |> File.stream!(encoding: :utf8)
      |> Enum.map(fn line ->
        Task.async(fn ->
          values =
            String.split(line, " ")
            |> Enum.map(&String.trim/1)
            |> Enum.map(&String.to_integer/1)

          Enum.reduce_while(values, {:safe, :first, :setup}, fn value, acc ->
            case acc do
              {_, :first, :setup} ->
                {:cont, {:safe, value, 0}}

              {_, prev, :setup} ->
                {:cont, {:safe, value, value - prev}}

              {_, prev, last_diff} ->
                result = value - prev

                case result do
                  result when abs(result) > 3 or abs(result) < 1 ->
                    {:halt, {:unsafe, 0, 0}}

                  result when result * last_diff < 0 ->
                    {:halt, {:unsafe, 0, 0}}

                  _ ->
                    {:cont, {:safe, value, result}}
                end
            end
          end)
        end)
      end)
      |> Task.await_many()
      |> Enum.split_with(fn {result, _, _} -> result == :safe end)

    length(safe)
  end
end
