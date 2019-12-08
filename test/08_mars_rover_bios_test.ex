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
      assert @digits |> MarsRoverBios.verify_image_integrity() == 2806
    end
  end
end
