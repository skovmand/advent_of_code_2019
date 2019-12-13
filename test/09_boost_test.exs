defmodule Advent19.BoostTest do
  @moduledoc """
  We receive a faint distress signal coming from the asteroid belt. It must be the Ceres monitoring station!
  In order to lock on to the signal, you'll need to boost your sensors. 
  The Elves send up the latest BOOST program - Basic Operation Of System Test.

  Note: This program just runs on the latest Intcode runtime
  The additional BOOST tests for the runtime are located in the intcode runtime tests
  """

  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.Intcode.Runner

  @program "input_09_boost.txt"
           |> Path.expand("./input_files")
           |> File.read!()
           |> Common.integer_list()

  describe "part 1: running the BOOST program" do
    test "running the program" do
      assert @program |> Runner.start_program(input: 1) == 2_465_411_646
    end
  end

  describe "part 2: running the BOOST program" do
    test "running the program" do
      assert @program |> Runner.start_program(input: 2) == 69781
    end
  end
end
