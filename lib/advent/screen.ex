defmodule Advent19.Screen do
  @moduledoc """
  Helper functions for drawing output to the screen
  """

  @doc """
  Convert a map of pixels into printable lines
  """
  def map_to_ascii(panel_map) do
    {{min_x, _}, _} = panel_map |> Enum.min_by(fn {{x, _y}, _} -> x end)
    {{_, min_y}, _} = panel_map |> Enum.min_by(fn {{_x, y}, _} -> y end)
    {{max_x, _}, _} = panel_map |> Enum.max_by(fn {{x, _y}, _} -> x end)
    {{_, max_y}, _} = panel_map |> Enum.max_by(fn {{_x, y}, _} -> y end)

    min_y..max_y
    |> Enum.to_list()
    |> Enum.map(fn row ->
      min_x..max_x
      |> Enum.to_list()
      |> Enum.map(fn column ->
        Map.get(panel_map, {column, row}, :nothing)
        |> case do
          :nothing -> "."
          :black -> "."
          :white -> "O"
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
