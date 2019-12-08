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

      assert program |> Common.integer_list() |> Amplification.run_serial([4, 3, 2, 1, 0]) == 43210
    end

    test "Max thruster signal 54321 (from phase setting sequence 0,1,2,3,4)" do
      program = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

      assert program |> Common.integer_list() |> Amplification.run_serial([0, 1, 2, 3, 4]) == 54321
    end

    test "Max thruster signal 65210 (from phase setting sequence 1,0,4,3,2)" do
      program = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

      assert program |> Common.integer_list() |> Amplification.run_serial([1, 0, 4, 3, 2]) == 65210
    end

    test "part 1 answer" do
      assert @opcode |> Amplification.optimum_phase() == 77500
    end
  end

  describe "part 2" do
    test "Max thruster signal 139629729 (from phase setting sequence 9,8,7,6,5)" do
      program = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"

      assert program |> Common.integer_list() |> Amplification.run_feedback([9, 8, 7, 6, 5]) == 139_629_729
    end

    test "Max thruster signal 18216 (from phase setting sequence 9,7,8,5,6)" do
      program =
        "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"

      assert program |> Common.integer_list() |> Amplification.run_feedback([9, 7, 8, 5, 6]) == 18216
    end

    test "part 2 answer" do
      assert @opcode |> Amplification.optimum_feedback_loop_phase() == 22_476_942
    end
  end
end
