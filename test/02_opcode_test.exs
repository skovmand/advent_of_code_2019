defmodule Advent19.OpcodeTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.Opcode

  @opcode "input_02_opcode.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.integer_list()

  describe "part 1" do
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
