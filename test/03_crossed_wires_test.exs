defmodule AdventOfCode2019.CrossedWiresTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.CrossedWires

  @wire_paths "input_03_crossed_wires.txt"
              |> Path.expand("./input_files")
              |> File.read!()

  describe "part 1: the intersection closest to the central port" do
    test "example 1" do
      input = """
      R75,D30,R83,U83,L12,D49,R71,U7,L72
      U62,R66,U55,R34,D71,R55,D58,R83
      """

      assert input |> CrossedWires.closest_distance() == 159
    end

    test "example 2" do
      input = """
      R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
      U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
      """

      assert input |> CrossedWires.closest_distance() == 135
    end

    test "the actual closest intersection" do
      assert @wire_paths |> CrossedWires.closest_distance() == 1519
    end
  end

  describe "part 2: the intersection with fewest steps" do
    test "example 1" do
      input = """
      R75,D30,R83,U83,L12,D49,R71,U7,L72
      U62,R66,U55,R34,D71,R55,D58,R83
      """

      assert input |> CrossedWires.shortest_path() == 610
    end

    test "example 2" do
      input = """
      R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
      U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
      """

      assert input |> CrossedWires.shortest_path() == 410
    end

    test "the actual closest intersection" do
      assert @wire_paths |> CrossedWires.shortest_path() == 14358
    end
  end
end
