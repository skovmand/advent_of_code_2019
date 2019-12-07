defmodule Advent19.AmplificationTest do
  use ExUnit.Case, async: true

  alias Advent19.Amplification
  alias Advent19.Common

  @opcode "input_07_amplification.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.integer_list()

  describe "part 1" do
    test "Max thruster signal 43210 (from phase setting sequence 4,3,2,1,0)" do
      program = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

      assert program |> Common.integer_list() |> Amplification.run([4,3,2,1,0]) == 43210
    end

    test "Max thruster signal 54321 (from phase setting sequence 0,1,2,3,4)" do
      program = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

      assert program |> Common.integer_list() |> Amplification.run([0,1,2,3,4]) == 54321
    end

    test "Max thruster signal 65210 (from phase setting sequence 1,0,4,3,2)" do
      program = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

      assert program |> Common.integer_list() |> Amplification.run([1,0,4,3,2]) == 65210
    end

    test "part 1 answer" do
      assert @opcode |> Amplification.optimum_phase() == 77500
    end
  end
end
