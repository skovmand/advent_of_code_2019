defmodule Advent19.IntcodeV9Test do
  @moduledoc """
  All tests for the Intcode computer V9 computer
  """

  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.Intcode.Runner
  alias Advent19.Intcode.Runtime

  describe "tests for relative mode, opcode 9, accessing arbitrary memory and using large numbers (day 9 part 1)" do
    test "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 produces a copy of itself" do
      program = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

      assert program |> Common.integer_list() |> Runner.start() ==
               [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    end

    test "1102,34915192,34915192,7,4,7,99,0 outputs a 16-digit number" do
      program = "1102,34915192,34915192,7,4,7,99,0"

      result = program |> Common.integer_list() |> Runner.start() |> List.first()

      assert result >= 1_000_000_000_000_000
      assert result < 10_000_000_000_000_000
    end

    test "104,1125899906842624,99 should output the large number in the middle" do
      program = "104,1125899906842624,99"

      assert program |> Common.integer_list() |> Runner.start() == [1_125_899_906_842_624]
    end
  end

  # General Intcode Computer tests from previous versions, not a complete collection, but getting there:

  describe "parsing opcodes (day 5 part 1)" do
    test "02" do
      assert Runtime.parse_opcode_and_position_params(02) == {2, :pos, :pos, :pos}
    end

    test "102" do
      assert Runtime.parse_opcode_and_position_params(102) == {2, :imm, :pos, :pos}
    end

    test "1002" do
      assert Runtime.parse_opcode_and_position_params(1002) == {2, :pos, :imm, :pos}
    end

    test "10102" do
      assert Runtime.parse_opcode_and_position_params(10102) == {2, :imm, :pos, :imm}
    end

    test "11102" do
      assert Runtime.parse_opcode_and_position_params(11102) == {2, :imm, :imm, :imm}
    end
  end

  describe "testing equality (day 5 part 2)" do
    # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,8,9,10,9,4,9,99,-1,8 with input 8" do
      assert "3,9,8,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> Runner.start(input: 8) == [1]
    end

    # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,8,9,10,9,4,9,99,-1,8 with input non-8" do
      assert "3,9,8,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> Runner.start(input: 99) == [0]
    end

    # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,7,9,10,9,4,9,99,-1,8 with input less than 8" do
      assert "3,9,7,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> Runner.start(input: 4) == [1]
    end

    # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,9,7,9,10,9,4,9,99,-1,8 with input greater than 8" do
      assert "3,9,7,9,10,9,4,9,99,-1,8" |> Common.integer_list() |> Runner.start(input: 40) == [0]
    end

    # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1108,-1,8,3,4,3,99 with input 8" do
      assert "3,3,1108,-1,8,3,4,3,99" |> Common.integer_list() |> Runner.start(input: 8) == [1]
    end

    # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1108,-1,8,3,4,3,99 with input non-8" do
      assert "3,3,1108,-1,8,3,4,3,99" |> Common.integer_list() |> Runner.start(input: 9) == [0]
    end

    # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1107,-1,8,3,4,3,99 with input less than 8" do
      assert "3,3,1107,-1,8,3,4,3,99" |> Common.integer_list() |> Runner.start(input: 4) == [1]
    end

    # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    test "3,3,1107,-1,8,3,4,3,99 with input greater than 8" do
      assert "3,3,1107,-1,8,3,4,3,99" |> Common.integer_list() |> Runner.start(input: 9) == [0]
    end
  end

  describe "jump tests (day 5 part 2)" do
    # Jump test 1
    test "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode) outputs 0 for input 0" do
      assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" |> Common.integer_list() |> Runner.start(input: 0) == [0]
    end

    # Jump test 1
    test "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode) outputs 1 for input 1" do
      assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" |> Common.integer_list() |> Runner.start(input: 1) == [1]
    end

    # Jump test 2
    test "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode) outputs 0 for input 0" do
      assert "3,3,1105,-1,9,1101,0,0,12,4,12,99,1" |> Common.integer_list() |> Runner.start(input: 0) == [0]
    end

    # Jump test 2
    test "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode) outputs 1 for input 1" do
      assert "3,3,1105,-1,9,1101,0,0,12,4,12,99,1" |> Common.integer_list() |> Runner.start(input: 1) == [1]
    end

    test "a larger example outputting 999 for input less than 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> Runner.start(input: 7) == [999]
    end

    test "a larger example outputting 999 for input equal to 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> Runner.start(input: 8) == [1000]
    end

    test "a larger example outputting 999 for input greater than 8" do
      program = """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """

      assert program |> Common.integer_list() |> Runner.start(input: 9) == [1001]
    end
  end
end
