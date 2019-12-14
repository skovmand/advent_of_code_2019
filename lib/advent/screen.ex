defmodule Advent19.Screen do
  @moduledoc """
  Helper functions for drawing output to the screen
  """

  @doc """
  Convert a map of pixels into printable lines
  """
  def map_to_ascii(panel_map, graphics_map, opts \\ []) do
    default_nothing_block = Keyword.get(opts, :nothing_block, ".")

    {{min_x, _}, _} = panel_map |> Enum.min_by(fn {{x, _y}, _} -> x end)
    {{_, min_y}, _} = panel_map |> Enum.min_by(fn {{_x, y}, _} -> y end)
    {{max_x, _}, _} = panel_map |> Enum.max_by(fn {{x, _y}, _} -> x end)
    {{_, max_y}, _} = panel_map |> Enum.max_by(fn {{_x, y}, _} -> y end)

    graphics =
      min_y..max_y
      |> Enum.map(fn row ->
        min_x..max_x
        |> Enum.map(fn column ->
          Map.get(panel_map, {column, row}, :nothing)
          |> case do
            :nothing -> default_nothing_block
            block -> Map.fetch!(graphics_map, block)
          end
        end)
        |> Enum.join("")
      end)

    if Keyword.get(opts, :flip_y, false) do
      graphics |> Enum.reverse() |> Enum.join("\n")
    else
      graphics |> Enum.join("\n")
    end
  end
end
