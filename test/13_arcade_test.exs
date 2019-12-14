defmodule Advent19.ArcadeTest do
  use ExUnit.Case, async: true

  alias Advent19.Arcade
  alias Advent19.Common

  @program "input_13_arcade.txt"
           |> Path.expand("./input_files")
           |> File.read!()
           |> Common.integer_list()

  describe "part 1" do
    test "The question: How many block tiles are on the screen when the game exits?" do
      assert @program |> Arcade.run_game(mode: :count_blocks) == 398
    end
  end

  describe "part 2" do
    test "Playing until no blocks are left" do
      # 1. Overwrite memory block 0 with value 2 to play for free on init --> OK
      # 2. Handle joystick input, -1 -> left, 0 -> neutral, 1 -> right - provide as input to the program (default to 0)
      # 3. Handle displaying the score on a second display by handling a third instruction --> OK

      assert @program |> Arcade.run_game(mode: :play_game) == 19447
    end
  end
end
