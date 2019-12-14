defmodule Advent19.NBodyProblemTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.NBodyProblem
  alias Advent19.NBodyProblem.Moon

  @input """
         <x=-10, y=-13, z=7>
         <x=1, y=2, z=1>
         <x=-15, y=-3, z=13>
         <x=3, y=7, z=-4>
         """
         |> Common.coordinates()

  # Convert a position and velocity block into a list of maps
  defp position_and_velocity(input_block) do
    input_block
    |> Common.string_list()
    |> Enum.flat_map(fn line ->
      String.split(line, [", vel=", "pos="])
      |> Enum.drop(1)
      |> Enum.map(&Common.string_to_coordinates/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [{px, py, pz}, {vx, vy, vz}] -> Moon.new({px, py, pz}, {vx, vy, vz}) end)
    end)
  end

  describe "the total energy of the system" do
    test "1st motion simulation" do
      input =
        """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
        """
        |> Common.coordinates()

      step_0_state =
        """
        pos=<x=-1, y=  0, z= 2>, vel=<x= 0, y= 0, z= 0>
        pos=<x= 2, y=-10, z=-7>, vel=<x= 0, y= 0, z= 0>
        pos=<x= 4, y= -8, z= 8>, vel=<x= 0, y= 0, z= 0>
        pos=<x= 3, y=  5, z=-1>, vel=<x= 0, y= 0, z= 0> 
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.init_moons() == step_0_state

      step_1_state =
        """
        pos=<x= 2, y=-1, z= 1>, vel=<x= 3, y=-1, z=-1>
        pos=<x= 3, y=-7, z=-4>, vel=<x= 1, y= 3, z= 3>
        pos=<x= 1, y=-7, z= 5>, vel=<x=-3, y= 1, z=-3>
        pos=<x= 2, y= 2, z= 0>, vel=<x=-1, y=-3, z= 1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(1) == step_1_state

      step_2_state =
        """
        pos=<x= 5, y=-3, z=-1>, vel=<x= 3, y=-2, z=-2>
        pos=<x= 1, y=-2, z= 2>, vel=<x=-2, y= 5, z= 6>
        pos=<x= 1, y=-4, z=-1>, vel=<x= 0, y= 3, z=-6>
        pos=<x= 1, y=-4, z= 2>, vel=<x=-1, y=-6, z= 2>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(2) == step_2_state

      step_3_state =
        """
        pos=<x= 5, y=-6, z=-1>, vel=<x= 0, y=-3, z= 0>
        pos=<x= 0, y= 0, z= 6>, vel=<x=-1, y= 2, z= 4>
        pos=<x= 2, y= 1, z=-5>, vel=<x= 1, y= 5, z=-4>
        pos=<x= 1, y=-8, z= 2>, vel=<x= 0, y=-4, z= 0>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(3) == step_3_state

      step_4_state =
        """
        pos=<x= 2, y=-8, z= 0>, vel=<x=-3, y=-2, z= 1>
        pos=<x= 2, y= 1, z= 7>, vel=<x= 2, y= 1, z= 1>
        pos=<x= 2, y= 3, z=-6>, vel=<x= 0, y= 2, z=-1>
        pos=<x= 2, y=-9, z= 1>, vel=<x= 1, y=-1, z=-1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(4) == step_4_state

      step_5_state =
        """
        pos=<x=-1, y=-9, z= 2>, vel=<x=-3, y=-1, z= 2>
        pos=<x= 4, y= 1, z= 5>, vel=<x= 2, y= 0, z=-2>
        pos=<x= 2, y= 2, z=-4>, vel=<x= 0, y=-1, z= 2>
        pos=<x= 3, y=-7, z=-1>, vel=<x= 1, y= 2, z=-2>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(5) == step_5_state

      step_6_state =
        """
        pos=<x=-1, y=-7, z= 3>, vel=<x= 0, y= 2, z= 1>
        pos=<x= 3, y= 0, z= 0>, vel=<x=-1, y=-1, z=-5>
        pos=<x= 3, y=-2, z= 1>, vel=<x= 1, y=-4, z= 5>
        pos=<x= 3, y=-4, z=-2>, vel=<x= 0, y= 3, z=-1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(6) == step_6_state

      step_7_state =
        """
        pos=<x= 2, y=-2, z= 1>, vel=<x= 3, y= 5, z=-2>
        pos=<x= 1, y=-4, z=-4>, vel=<x=-2, y=-4, z=-4>
        pos=<x= 3, y=-7, z= 5>, vel=<x= 0, y=-5, z= 4>
        pos=<x= 2, y= 0, z= 0>, vel=<x=-1, y= 4, z= 2>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(7) == step_7_state

      step_8_state =
        """
        pos=<x= 5, y= 2, z=-2>, vel=<x= 3, y= 4, z=-3>
        pos=<x= 2, y=-7, z=-5>, vel=<x= 1, y=-3, z=-1>
        pos=<x= 0, y=-9, z= 6>, vel=<x=-3, y=-2, z= 1>
        pos=<x= 1, y= 1, z= 3>, vel=<x=-1, y= 1, z= 3>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(8) == step_8_state

      step_9_state =
        """
        pos=<x= 5, y= 3, z=-4>, vel=<x= 0, y= 1, z=-2>
        pos=<x= 2, y=-9, z=-3>, vel=<x= 0, y=-2, z= 2>
        pos=<x= 0, y=-8, z= 4>, vel=<x= 0, y= 1, z=-2>
        pos=<x= 1, y= 1, z= 5>, vel=<x= 0, y= 0, z= 2>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(9) == step_9_state

      step_10_state =
        """
        pos=<x= 2, y= 1, z=-3>, vel=<x=-3, y=-2, z= 1>
        pos=<x= 1, y=-8, z= 0>, vel=<x=-1, y= 1, z= 3>
        pos=<x= 3, y=-6, z= 1>, vel=<x= 3, y= 2, z=-3>
        pos=<x= 2, y= 0, z= 4>, vel=<x= 1, y=-1, z=-1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(10) == step_10_state

      assert step_10_state |> NBodyProblem.total_kinetic_energy() == 179
    end

    test "2nd motion simulation" do
      input =
        """
        <x=-8, y=-10, z=0>
        <x=5, y=5, z=10>
        <x=2, y=-7, z=3>
        <x=9, y=-8, z=-3>
        """
        |> Common.coordinates()

      step_0_state =
        """
        pos=<x= -8, y=-10, z=  0>, vel=<x=  0, y=  0, z=  0>
        pos=<x=  5, y=  5, z= 10>, vel=<x=  0, y=  0, z=  0>
        pos=<x=  2, y= -7, z=  3>, vel=<x=  0, y=  0, z=  0>
        pos=<x=  9, y= -8, z= -3>, vel=<x=  0, y=  0, z=  0>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.init_moons() == step_0_state

      step_10_state =
        """
        pos=<x= -9, y=-10, z=  1>, vel=<x= -2, y= -2, z= -1>
        pos=<x=  4, y= 10, z=  9>, vel=<x= -3, y=  7, z= -2>
        pos=<x=  8, y=-10, z= -3>, vel=<x=  5, y= -1, z= -2>
        pos=<x=  5, y=-10, z=  3>, vel=<x=  0, y= -4, z=  5>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(10) == step_10_state

      step_20_state =
        """
        pos=<x=-10, y=  3, z= -4>, vel=<x= -5, y=  2, z=  0>
        pos=<x=  5, y=-25, z=  6>, vel=<x=  1, y=  1, z= -4>
        pos=<x= 13, y=  1, z=  1>, vel=<x=  5, y= -2, z=  2>
        pos=<x=  0, y=  1, z=  7>, vel=<x= -1, y= -1, z=  2>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(20) == step_20_state

      step_30_state =
        """
        pos=<x= 15, y= -6, z= -9>, vel=<x= -5, y=  4, z=  0>
        pos=<x= -4, y=-11, z=  3>, vel=<x= -3, y=-10, z=  0>
        pos=<x=  0, y= -1, z= 11>, vel=<x=  7, y=  4, z=  3>
        pos=<x= -3, y= -2, z=  5>, vel=<x=  1, y=  2, z= -3>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(30) == step_30_state

      step_40_state =
        """
        pos=<x= 14, y=-12, z= -4>, vel=<x= 11, y=  3, z=  0>
        pos=<x= -1, y= 18, z=  8>, vel=<x= -5, y=  2, z=  3>
        pos=<x= -5, y=-14, z=  8>, vel=<x=  1, y= -2, z=  0>
        pos=<x=  0, y=-12, z= -2>, vel=<x= -7, y= -3, z= -3>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(40) == step_40_state

      step_50_state =
        """
        pos=<x=-23, y=  4, z=  1>, vel=<x= -7, y= -1, z=  2>
        pos=<x= 20, y=-31, z= 13>, vel=<x=  5, y=  3, z=  4>
        pos=<x= -4, y=  6, z=  1>, vel=<x= -1, y=  1, z= -3>
        pos=<x= 15, y=  1, z= -5>, vel=<x=  3, y= -3, z= -3>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(50) == step_50_state

      step_60_state =
        """
        pos=<x= 36, y=-10, z=  6>, vel=<x=  5, y=  0, z=  3>
        pos=<x=-18, y= 10, z=  9>, vel=<x= -3, y= -7, z=  5>
        pos=<x=  8, y=-12, z= -3>, vel=<x= -2, y=  1, z= -7>
        pos=<x=-18, y= -8, z= -2>, vel=<x=  0, y=  6, z= -1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(60) == step_60_state

      step_70_state =
        """
        pos=<x=-33, y= -6, z=  5>, vel=<x= -5, y= -4, z=  7>
        pos=<x= 13, y= -9, z=  2>, vel=<x= -2, y= 11, z=  3>
        pos=<x= 11, y= -8, z=  2>, vel=<x=  8, y= -6, z= -7>
        pos=<x= 17, y=  3, z=  1>, vel=<x= -1, y= -1, z= -3>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(70) == step_70_state

      step_80_state =
        """
        pos=<x= 30, y= -8, z=  3>, vel=<x=  3, y=  3, z=  0>
        pos=<x= -2, y= -4, z=  0>, vel=<x=  4, y=-13, z=  2>
        pos=<x=-18, y= -7, z= 15>, vel=<x= -8, y=  2, z= -2>
        pos=<x= -2, y= -1, z= -8>, vel=<x=  1, y=  8, z=  0>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(80) == step_80_state

      step_90_state =
        """
        pos=<x=-25, y= -1, z=  4>, vel=<x=  1, y= -3, z=  4>
        pos=<x=  2, y= -9, z=  0>, vel=<x= -3, y= 13, z= -1>
        pos=<x= 32, y= -8, z= 14>, vel=<x=  5, y= -4, z=  6>
        pos=<x= -1, y= -2, z= -8>, vel=<x= -3, y= -6, z= -9>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(90) == step_90_state

      step_100_state =
        """
        pos=<x=  8, y=-12, z= -9>, vel=<x= -7, y=  3, z=  0>
        pos=<x= 13, y= 16, z= -3>, vel=<x=  3, y=-11, z= -5>
        pos=<x=-29, y=-11, z= -1>, vel=<x= -3, y=  7, z=  4>
        pos=<x= 16, y=-13, z= 23>, vel=<x=  7, y=  1, z=  1>
        """
        |> position_and_velocity()

      assert input |> NBodyProblem.moon_state(100) == step_100_state

      assert step_100_state |> NBodyProblem.total_kinetic_energy() == 1940
    end

    test "the answer to part 1" do
      assert @input |> NBodyProblem.total_kinetic_energy(1000) == 8454
    end
  end
end
