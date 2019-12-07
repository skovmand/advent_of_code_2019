defmodule AdventOfCode2019.OrbitsTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.Common
  alias AdventOfCode2019.Orbits

  @opcode "input_06_orbits.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.string_list()

  describe "part 1" do
    test "sample orbits" do
      orbit_input =
        """
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        """
        |> Common.string_list()

      assert orbit_input |> Orbits.count_total_orbits() == 42
    end

    test "solving the input" do
      assert @opcode |> Orbits.count_total_orbits() == 200_001
    end
  end

  describe "part 2" do
    test "sample orbital transfer" do
      orbit_input =
        """
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        K)YOU
        I)SAN
        """
        |> Common.string_list()

      assert orbit_input |> Orbits.count_orbit_transfers() == 4
    end

    test "solving the input for part 2" do
      assert @opcode |> Orbits.count_orbit_transfers() == 379
    end
  end
end
