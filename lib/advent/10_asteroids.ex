defmodule Advent19.Asteroids do
  @moduledoc """
  Finding the best position for an asteroid monitoring station
  """

  # The precision for rounding floats
  @precision 5

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
      |> visible_asteroids()
      |> Enum.max_by(fn {_coords, visible_asteroids} -> visible_asteroids |> length() end)

    {position |> flip_y_axis(), visible_asteroids |> length()}
  end

  # Create a map of all asteroids in the field
  defp parse_field(field) do
    field
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.with_index(&1))
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> {row, -1 * index} end)
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

  defp visible_asteroids(field_map) do
    field_map
    |> Enum.into(%{}, fn {{x, y} = _own_position, _} ->
      angles_to_asteroids =
        field_map
        |> asteroids_grouped_by_angle({x, y})
        |> remove_invisible_asteroids({x, y})

      {{x, y}, angles_to_asteroids}
    end)
  end

  # From a point of view (own position), group all asteroids by their angle
  defp asteroids_grouped_by_angle(field_map, {x, y} = _own_position) do
    # We will round floats to this position
    horizontal_vector = {1, 0}

    field_map
    |> Map.delete({x, y})
    |> Enum.map(fn {{x_1, y_1}, _} ->
      vector = Vectors.from({x, y}, {x_1, y_1})

      {{x_1, y_1}, Vectors.vector_angle(horizontal_vector, vector)}
    end)
    |> Enum.group_by(fn {{_x_1, _y_1}, angle} -> angle |> Float.ceil(@precision) end, fn {coords, _angle} -> coords end)
  end

  # If more than one asteroid has the same angle, only keep the closest asteroid
  defp remove_invisible_asteroids(asteroids_grouped_by_angle, own_position) do
    asteroids_grouped_by_angle
    |> Enum.flat_map(fn {_angle, target_coords} ->
      case target_coords |> Enum.count() do
        1 ->
          target_coords

        _more_than_one_target ->
          Enum.min_by(target_coords, fn target_coords ->
            Vectors.from(own_position, target_coords) |> Vectors.vector_length()
          end)
          |> List.wrap()
      end
    end)
  end

  @doc """
  Find the 200th asteroid burned by the laser
  """
  def count_nth_burned_asteroid(field, own_position, n) do
    field
    |> parse_field()
    |> reject_empty_space()
    |> asteroids_grouped_by_angle(own_position)
    |> unit_circle_sorted()
    |> order_asteroids_by_distance(own_position)
    |> laser_burn_order()
    |> Enum.at(n - 1)
    |> flip_y_axis()
  end

  defp flip_y_axis({x, y}), do: {x, -1 * y}

  # Sort the map of angle grouped asteroids to match the order of the laser hits
  # - the ones equaling pi/2 are first
  # - then descending towards zero, at the end equaling zero
  # - then sorted descending with the biggest first
  defp unit_circle_sorted(angle_grouped) do
    half_pi = (:math.pi() / 2) |> Float.ceil(@precision)

    first_quarter =
      angle_grouped
      |> Enum.filter(fn {angle, _v} -> angle <= half_pi and angle >= 0 end)
      |> Enum.sort(&(&1 >= &2))

    remaining_circle =
      angle_grouped
      |> Enum.filter(fn {angle, _v} -> angle > half_pi end)
      |> Enum.sort(&(&1 >= &2))

    first_quarter ++ remaining_circle
  end

  # Sort all asteroids with the same angle by their distance to own_position
  defp order_asteroids_by_distance(sorted_angle_list, own_position) do
    sorted_angle_list
    |> Enum.map(fn {angle, asteroid_coords} ->
      sorted_asteroids =
        asteroid_coords
        |> Enum.sort_by(fn target_coords ->
          Vectors.from(own_position, target_coords) |> Vectors.vector_length()
        end)

      {angle, sorted_asteroids}
    end)
  end

  # Order asteroid coordinates in the order they will be burned
  defp laser_burn_order(angle_grouped) do
    max_depth = angle_grouped |> Enum.max_by(fn {_angle, asteroids} -> length(asteroids) end) |> elem(1) |> length()

    0..(max_depth - 1)
    |> Enum.reduce([], fn laser_round, burn_list ->
      burned_this_round =
        angle_grouped
        |> Enum.flat_map(fn {_angle, asteroids} ->
          case asteroids |> List.pop_at(laser_round) do
            {{x, y}, _remaining} -> [{x, y}]
            {nil, _remaining} -> []
          end
        end)

      burn_list ++ burned_this_round
    end)
  end
end
