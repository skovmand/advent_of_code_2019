defmodule AdventOfCode2019.Orbits do
  @moduledoc """
  Calculating Orbits
  """

  @doc """
  Part 1: Count total direct and indirect orbits
  """
  def count_total_orbits(orbit_input) do
    orbit_input
    |> orbit_map()
    |> count_orbits("COM")
  end

  @doc """
  Part 2: Count orbit transfers from YOU to SAN
  """
  def count_orbit_transfers(orbit_input) do
    orbits = orbit_input |> orbit_map()

    path_you_to_centre = path_to_centre(orbits, "YOU")
    path_san_to_centre = path_to_centre(orbits, "SAN")

    count_unique_bodies(path_you_to_centre, path_san_to_centre)
  end

  # Draw the map of orbits as a flat map
  defp orbit_map(orbit_input) do
    orbit_input
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.group_by(&List.first/1, &List.last/1)
  end

  # Count amount of orbits by walking from COM to the end of all branches
  defp count_orbits(orbit_map, center, distance \\ 0) do
    distance = distance + 1
    bodies = orbit_map |> Map.get(center, [])
    orbits_for_body = (bodies |> length()) * distance

    # For each sub orbit, call the function again, counting their total orbits and sub-orbits
    sub_orbits = bodies |> Enum.reduce(0, fn body, acc -> acc + count_orbits(orbit_map, body, distance) end)

    orbits_for_body + sub_orbits
  end

  # Walk backwards from a given body to COM accumulating a list of body labels
  defp path_to_centre(orbit_map, start_body) do
    do_find_path_to_centre(orbit_map, start_body, [])
  end

  defp do_find_path_to_centre(orbit_map, start_body, acc) do
    case find_parent(orbit_map, start_body) do
      nil -> acc
      {parent, _} -> do_find_path_to_centre(orbit_map, parent, [parent | acc])
    end
  end

  # Find a parent body from a known body label. Can be used to find the parent of SAN and YOU.
  defp find_parent(orbit_map, start_body) do
    Enum.find(orbit_map, fn {_k, v} -> start_body in v end)
  end

  # Counts unique bodies in two lists of paths (removes the common parts to find the shortest transfer distance)
  defp count_unique_bodies(list1, list2) do
    do_count_unique_bodies(list1, list2, 0)
  end

  defp do_count_unique_bodies([a | tail1], [a | tail2], count), do: do_count_unique_bodies(tail1, tail2, count)
  defp do_count_unique_bodies([_ | tail1], [_ | tail2], count), do: do_count_unique_bodies(tail1, tail2, count + 2)
  defp do_count_unique_bodies([_ | tail1], [], count), do: do_count_unique_bodies(tail1, [], count + 1)
  defp do_count_unique_bodies([], [_ | tail2], count), do: do_count_unique_bodies([], tail2, count + 1)
  defp do_count_unique_bodies([], [], count), do: count
end
