defmodule Advent19.ThermalTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.IntcodeV2

  describe "parsing opcodes" do
    test "02" do
      assert IntcodeV2.parse_first_opcode([02]) == [{2, :pos, :pos, :pos}]
    end

    test "102" do
      assert IntcodeV2.parse_first_opcode([102]) == [{2, :imm, :pos, :pos}]
    end

    test "1002" do
      assert IntcodeV2.parse_first_opcode([1002]) == [{2, :pos, :imm, :pos}]
    end

    test "10102" do
      assert IntcodeV2.parse_first_opcode([10102]) == [{2, :imm, :pos, :imm}]
    end

    test "11102" do
      assert IntcodeV2.parse_first_opcode([11102]) == [{2, :imm, :imm, :imm}]
    end
  end

  @opcode "input_05_thermal.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.integer_list()

  describe "part 1" do
    test "solves the puzzle" do
      assert @opcode |> IntcodeV2.compute_result([1]) |> Enum.at(-1) == 6_731_945
    end
  end

  describe "part 2" do
    # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,8,9,10,9,4,9,99,-1,8 with input 8" do
      assert "3,9,8,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> IntcodeV2.compute_result([8]) == [1]
    end

    # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,8,9,10,9,4,9,99,-1,8 with input non-8" do
      assert "3,9,8,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> IntcodeV2.compute_result([99]) == [0]
    end

    # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,7,9,10,9,4,9,99,-1,8 with input less than 8" do
      assert "3,9,7,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> IntcodeV2.compute_result([4]) == [1]
    end

    # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,7,9,10,9,4,9,99,-1,8 with input greater than 8" do
      assert "3,9,7,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> IntcodeV2.compute_result([40]) == [0]
    end

    # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1108,-1,8,3,4,3,99 with input 8" do
      assert "3,3,1108,-1,8,3,4,3,99" |> Common.integer_list() |> IntcodeV2.compute_result([8]) == [1]
    end

    # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1108,-1,8,3,4,3,99 with input non-8" do
      assert "3,3,1108,-1,8,3,4,3,99" |> Common.integer_list() |> IntcodeV2.compute_result([9]) == [0]
    end

    # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1107,-1,8,3,4,3,99 with input less than 8" do
      assert "3,3,1107,-1,8,3,4,3,99" |> Common.integer_list() |> IntcodeV2.compute_result([4]) == [1]
    end

    # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1107,-1,8,3,4,3,99 with input greater than 8" do
      assert "3,3,1107,-1,8,3,4,3,99" |> Common.integer_list() |> IntcodeV2.compute_result([9]) == [0]
    end

    # Jump test 1
    test "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode) outputs 0 for input 0" do
      assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
             |> Common.integer_list()
             |> IntcodeV2.compute_result([0]) == [0]
    end

    # Jump test 1
    test "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode) outputs 1 for input 1" do
      assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
             |> Common.integer_list()
             |> IntcodeV2.compute_result([1]) == [1]
    end

    # Jump test 2
    test "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode) outputs 0 for input 0" do
      assert "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
             |> Common.integer_list()
             |> IntcodeV2.compute_result([0]) == [0]
    end

    # Jump test 2
    test "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode) outputs 1 for input 1" do
      assert "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
             |> Common.integer_list()
             |> IntcodeV2.compute_result([1]) == [1]
    end

    test "a larger example outputting 999 for input less than 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> IntcodeV2.compute_result([7]) == [999]
    end

    test "a larger example outputting 999 for input equal to 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> IntcodeV2.compute_result([8]) == [1000]
    end

    test "a larger example outputting 999 for input greater than 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> IntcodeV2.compute_result([9]) == [1001]
    end

    test "solves the puzzle to extend the thermal radiators" do
      assert @opcode |> IntcodeV2.compute_result([5]) |> List.first() == 9_571_668
    end
  end
end
