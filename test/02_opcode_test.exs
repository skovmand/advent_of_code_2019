defmodule Advent19.OpcodeTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.Opcode

  @opcode "input_02_opcode.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.integer_list()

  describe "part 1" do
    test "1,0,0,0,99 becomes 2,0,0,0,99" do
      assert [1, 0, 0, 0, 99] |> Opcode.compute() == [2, 0, 0, 0, 99]
    end

    test "2,3,0,3,99 becomes 2,3,0,6,99" do
      assert [2, 3, 0, 3, 99] |> Opcode.compute() == [2, 3, 0, 6, 99]
    end

    test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801" do
      assert [2, 4, 4, 5, 99, 0] |> Opcode.compute() == [2, 4, 4, 5, 99, 9801]
    end

    test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99" do
      assert [1, 1, 1, 4, 99, 5, 6, 0, 99] |> Opcode.compute() == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "restore the gravity assist program to the 1202 program alarm" do
      assert @opcode |> Opcode.compute_result(12, 2) == 4_714_701
    end
  end

  describe "part 2" do
    test "combination to get 19690720" do
      assert Opcode.brute_force_inputs(@opcode) == {51, 21}
    end
  end
end
