defmodule Advent19.Asteroids do
  @moduledoc """
  Finding the best position for an asteroid monitoring station
  """

  alias Advent19.Vectors

  @doc """
  Given an asteroid field, find the best location for a monitoring station

  We will count how many asteroids are in the line of sight by:
  - calculating angles from every asteroid to all other asteroids
  - then removing all angles which have duplicates by keeping the nearest asteroid
  """
  def find_best_station(field) do
    {position, visible_asteroids} =
      field
      |> parse_field()
      |> reject_empty_space()
      |> angles_to_other_asteroids()
      |> Enum.max_by(fn {_coords, visible_asteroids} -> visible_asteroids |> length() end)

    {position, visible_asteroids |> length()}
  end

  # Create a map of all asteroids in the field
  defp parse_field(field) do
    field
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.with_index(&1))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> Enum.reduce(%{}, fn {content, x}, acc ->
        acc |> Map.put(x, content)
      end)
      |> Enum.into(%{}, fn {x, content} -> {{x, y}, content} end)
      |> Map.merge(acc)
    end)
  end

  defp reject_empty_space(field_map) do
    field_map |> Enum.reject(fn {_k, v} -> v == "." end) |> Enum.into(%{})
  end

  defp angles_to_other_asteroids(field_map) do
    horizontal_vector = {1, 0}

    field_map
    |> Enum.into(%{}, fn {{x, y} = source_coords, _} ->
      angles_to_asteroids =
        field_map
        |> Map.delete({x, y})
        |> Enum.map(fn {{x_1, y_1}, _} ->
          vector = Vectors.from({x, y}, {x_1, y_1})

          {{x_1, y_1}, Vectors.vector_angle(horizontal_vector, vector)}
        end)
        |> Enum.group_by(fn {{_x_1, _y_1}, angle} -> angle |> Float.ceil(5) end, fn {coords, _angle} -> coords end)
        |> Enum.flat_map(fn {_angle, target_coords} ->
          case target_coords |> Enum.count() do
            1 ->
              target_coords

            _more_than_one_target ->
              [
                Enum.min_by(target_coords, fn target_coords ->
                  Vectors.from(source_coords, target_coords) |> Vectors.vector_length()
                end)
              ]
          end
        end)

      {{x, y}, angles_to_asteroids}
    end)
  end
end
