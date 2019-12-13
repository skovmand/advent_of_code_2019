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
      assert @program |> Paint.paint_spaceship() == 1894
    end
  end
end
