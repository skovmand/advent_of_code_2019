defmodule AdventOfCode2019.CrossedWires do
  @moduledoc """
  Find the intersection point closest to the central port
  """

  defmodule CoordinateSystem do
    @moduledoc """
    A coordinate system for e.g. drawing wires
    """

    def new(), do: %{}

    def get(coordinate_system, {x, y}), do: Map.fetch(coordinate_system, {x, y})

    def put(coordinate_system, {x, y}, tag) do
      coordinate_system
      |> Map.update({x, y}, MapSet.new() |> MapSet.put(tag), fn set -> MapSet.put(set, tag) end)
    end

    # Fill right or left (y is unchanged)
    def fill(coordinate_system, {x1, y}, {x2, y}, tag) do
      x1..x2
      |> Enum.map(fn x -> {x, y} end)
      |> fill_coordinates(coordinate_system, tag)
    end

    # Fill up or down (x is unchanged)
    def fill(coordinate_system, {x, y1}, {x, y2}, tag) do
      y1..y2
      |> Enum.map(fn y -> {x, y} end)
      |> fill_coordinates(coordinate_system, tag)
    end

    defp fill_coordinates(coordinates, coordinate_system, tag) do
      coordinates
      |> Enum.reduce(coordinate_system, fn {x, y}, coordinate_system -> coordinate_system |> put({x, y}, tag) end)
    end

    def intersections(coordinate_system) do
      coordinate_system
      |> Enum.filter(fn {_position, set} -> set |> MapSet.size() == 2 end)
      |> Enum.map(fn {position, _set} -> position end)
    end
  end

  @doc """
  Find the intersection with the lowest distance to the central port
  """
  def closest_distance(input) do
    [first_wire_path, second_wire_path] = input |> to_instructions()

    diagram = CoordinateSystem.new()

    [{first_wire_path, :fw}, {second_wire_path, :sw}]
    |> Enum.reduce(diagram, fn {wire_path, tag}, diagram -> fill_wire_path(wire_path, diagram, tag) end)
    |> CoordinateSystem.intersections()
    |> Enum.reject(fn {x, y} -> {x, y} == {0, 0} end)
    |> Enum.min_by(&manhattan_distance/1)
    |> manhattan_distance()
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  defp to_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn one_line -> one_line |> Enum.map(&string_to_instruction/1) end)
  end

  defp fill_wire_path(wire_path, diagram, tag) do
    wire_path
    |> Enum.reduce({{0, 0}, diagram}, fn {direction, amount}, {from_position, diagram} ->
      to_position = new_position(from_position, direction, amount)
      diagram = diagram |> CoordinateSystem.fill(from_position, to_position, tag)

      {to_position, diagram}
    end)
    |> elem(1)
  end

  defp string_to_instruction("R" <> number), do: {:right, String.to_integer(number)}
  defp string_to_instruction("L" <> number), do: {:left, String.to_integer(number)}
  defp string_to_instruction("U" <> number), do: {:up, String.to_integer(number)}
  defp string_to_instruction("D" <> number), do: {:down, String.to_integer(number)}

  defp new_position({x, y}, :right, amount), do: {x + amount, y}
  defp new_position({x, y}, :left, amount), do: {x - amount, y}
  defp new_position({x, y}, :up, amount), do: {x, y + amount}
  defp new_position({x, y}, :down, amount), do: {x, y - amount}
end
