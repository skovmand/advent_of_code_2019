defmodule AdventOfCode2019.OpcodeTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.Opcode

  @opcode "input_02_opcode.txt"
          |> Path.expand("./test")
          |> File.read!()
          |> String.split([",", "\n"], trim: true)
          |> Enum.map(&String.to_integer/1)

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
      assert [1,1,1,4,99,5,6,0,99] |> Opcode.compute() == [30,1,1,4,2,5,6,0,99]
    end

    test "restore the gravity assist program to the 1202 program alarm" do
      assert @opcode
      |> List.update_at(1, fn _ -> 12 end)
      |> List.update_at(2, fn _ -> 2 end)
      |> Opcode.compute()
      |> Enum.at(0) == 4714701
    end
  end
end
