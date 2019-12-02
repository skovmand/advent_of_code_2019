defmodule AdventOfCode2019.FuelRequirementsTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.FuelRequirements

  @numbers "input_01_fuel.txt"
           |> Path.expand("./test")
           |> File.read!()
           |> String.split("\n", trim: true)
           |> Enum.map(&String.to_integer/1)

  describe "part 1" do
    test "For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2" do
      assert FuelRequirements.mass_to_fuel(12) == 2
    end

    test "For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2" do
      assert FuelRequirements.mass_to_fuel(14) == 2
    end

    test "For a mass of 1969, the fuel required is 654" do
      assert FuelRequirements.mass_to_fuel(1969) == 654
    end

    test "For a mass of 100756, the fuel required is 33583" do
      assert FuelRequirements.mass_to_fuel(100_756) == 33_583
    end

    test "answer: calculating total fuel needed for a list of module masses" do
      assert @numbers |> FuelRequirements.mass_list_to_fuel() == 3_295_424
    end
  end

  describe "part 2" do
    test "A module mass of 14 requires 2 fuel" do
      assert FuelRequirements.mass_to_total_fuel(14) == 2
    end

    test "A module mass of 1969 requires 966 fuel" do
      assert FuelRequirements.mass_to_total_fuel(1969) == 966
    end

    test "A module mass of 100756 requires 50346 fuel" do
      assert FuelRequirements.mass_to_total_fuel(100_756) == 50346
    end

    test "part 2: calculating the needed fuel for the extra fuel" do
      assert @numbers |> FuelRequirements.mass_list_to_total_fuel() == 4_940_279
    end
  end
end
