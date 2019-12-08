defmodule Advent19.MarsRoverBiosTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.MarsRoverBios

  @digits "input_08_mars_rover_bios.txt"
          |> Path.expand("./input_files")
          |> File.read!()
          |> Common.single_digit_list()

  describe "part 1" do
    test "checking the image integrity" do
      assert @digits |> MarsRoverBios.verify_image_integrity(6, 25) == 2806
    end
  end

  describe "part 2" do
    test "test image" do
      assert "0222112222120000" |> Common.single_digit_list() |> MarsRoverBios.decode_image(2, 2) == [[0, 1], [1, 0]]
    end

    test "answering the puzzle" do
      answer = """
      OOOO OOO    OO  OO  OOO  
         O O  O    O O  O O  O 
        O  OOO     O O  O OOO  
       O   O  O    O OOOO O  O 
      O    O  O O  O O  O O  O 
      OOOO OOO   OO  O  O OOO
      """

      assert @digits |> MarsRoverBios.draw_image(6, 25) |> String.trim() == answer |> String.trim()
    end
  end
end
