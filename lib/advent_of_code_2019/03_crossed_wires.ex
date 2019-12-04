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

    @doc """
    Put a value into coordinates
    If a value is already present, use the lowest of the two
    """
    def put(coordinate_system, {x, y}, value) when is_integer(value) do
      coordinate_system |> Map.update({x, y}, value, fn existing_value -> min(value, existing_value) end)
    end

    # Fill right or left (y is unchanged)
    def fill(coordinate_system, {x1, y}, {x2, y}, step_count_offset) do
      x1..x2
      |> Enum.map(fn x -> {x, y} end)
      |> fill_coordinates(coordinate_system, step_count_offset)
    end

    # Fill up or down (x is unchanged)
    def fill(coordinate_system, {x, y1}, {x, y2}, step_count_offset) do
      y1..y2
      |> Enum.map(fn y -> {x, y} end)
      |> fill_coordinates(coordinate_system, step_count_offset)
    end

    defp fill_coordinates(coordinates, coordinate_system, step_count_offset) do
      coordinates
      |> Enum.with_index()
      |> Enum.reduce(coordinate_system, fn {{x, y}, count}, coordinate_system ->
        coordinate_system |> put({x, y}, step_count_offset + count)
      end)
    end

    def intersection(cs1, cs2) do
      cs1_keys = cs1 |> Map.keys() |> MapSet.new()
      cs2_keys = cs2 |> Map.keys() |> MapSet.new()

      MapSet.intersection(cs1_keys, cs2_keys) |> MapSet.to_list()
    end
  end

  @doc """
  Find the intersection with the lowest distance to the central port
  """
  def closest_distance(input) do
    [first_wire_path, second_wire_path] = input |> to_instructions()

    first_wire_diagram = fill_wire_path(first_wire_path, CoordinateSystem.new())
    second_wire_diagram = fill_wire_path(second_wire_path, CoordinateSystem.new())

    CoordinateSystem.intersection(first_wire_diagram, second_wire_diagram)
    |> Enum.reject(fn {x, y} -> {x, y} == {0, 0} end)
    |> Enum.min_by(&manhattan_distance/1)
    |> manhattan_distance()
  end

  @doc """
  Find the intersection with the lowest distance to the central port
  """
  def shortest_path(input) do
    [first_wire_path, second_wire_path] = input |> to_instructions()

    first_wire_diagram = fill_wire_path(first_wire_path, CoordinateSystem.new())
    second_wire_diagram = fill_wire_path(second_wire_path, CoordinateSystem.new())

    CoordinateSystem.intersection(first_wire_diagram, second_wire_diagram)
    |> Enum.reject(fn {x, y} -> {x, y} == {0, 0} end)
    |> Enum.map(fn {x, y} ->
      first_step_count = first_wire_diagram |> Map.fetch!({x, y})
      second_step_count = second_wire_diagram |> Map.fetch!({x, y})

      first_step_count + second_step_count
    end)
    |> Enum.min()
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  defp to_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn one_line -> one_line |> Enum.map(&string_to_instruction/1) end)
  end

  defp fill_wire_path(wire_path, diagram) do
    wire_path
    |> Enum.reduce({{0, 0}, 0, diagram}, fn {direction, amount}, {from_position, step_count, diagram} ->
      to_position = new_position(from_position, direction, amount)
      diagram = diagram |> CoordinateSystem.fill(from_position, to_position, step_count)

      {to_position, step_count + amount, diagram}
    end)
    |> elem(2)
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
