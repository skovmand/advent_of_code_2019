defmodule AdventOfCode2019.ThermalTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.Thermal

  describe "parsing opcodes" do
    test "02" do
      assert Thermal.parse_first_opcode([02]) == [{2, :pos, :pos, :pos}]
    end

    test "102" do
      assert Thermal.parse_first_opcode([102]) == [{2, :imm, :pos, :pos}]
    end

    test "1002" do
      assert Thermal.parse_first_opcode([1002]) == [{2, :pos, :imm, :pos}]
    end

    test "10102" do
      assert Thermal.parse_first_opcode([10102]) == [{2, :imm, :pos, :imm}]
    end

    test "11102" do
      assert Thermal.parse_first_opcode([11102]) == [{2, :imm, :imm, :imm}]
    end
  end

  @opcode "input_05_thermal.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> String.split([",", "\n"], trim: true)
          |> Enum.map(&String.to_integer/1)

  describe "part 1" do
    test "solves the puzzle" do
      assert @opcode |> Thermal.compute_result([1]) |> Enum.at(-1) == 6731945
    end
  end
end
