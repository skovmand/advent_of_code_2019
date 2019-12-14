defmodule Advent19.PaintTest do
  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.Paint

  @program "input_11_paint.txt"
           |> Path.expand("./input_files")
           |> File.read!()
           |> Common.integer_list()

  describe "part 1" do
    test "calculates the answer correctly" do
      assert @program |> Paint.paint_spaceship(:black, :count) == 1894
    end
  end

  describe "part 2" do
    test "calculates the answer correctly" do
      answer =
        """
        ...OO.O..O.OOOO.O....OOOO...OO.OOO..O..O...
        ....O.O.O.....O.O.......O....O.O..O.O..O...
        ....O.OO.....O..O......O.....O.OOO..OOOO...
        ....O.O.O...O...O.....O......O.O..O.O..O...
        .O..O.O.O..O....O....O....O..O.O..O.O..O...
        ..OO..O..O.OOOO.OOOO.OOOO..OO..OOO..O..O...
        """
        |> String.trim()

      assert @program |> Paint.paint_spaceship(:white, :draw) |> String.trim() == answer
    end
  end
end
