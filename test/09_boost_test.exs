defmodule Advent19.BoostTest do
  @moduledoc """
  We receive a faint distress signal coming from the asteroid belt. It must be the Ceres monitoring station!
  In order to lock on to the signal, you'll need to boost your sensors. 
  The Elves send up the latest BOOST program - Basic Operation Of System Test.
  """

  # Other tests for the Intcode computer is in intcode_v9_test.exs

  use ExUnit.Case, async: true

  alias Advent19.Common
  alias Advent19.IntcodeV9

  @program "input_09_boost.txt"
           |> Path.expand("./input_files")
           |> File.read!()
           |> Common.integer_list()

  describe "part 1: running the BOOST program" do
    test "running the program" do
      assert @program |> IntcodeV9.compute_result([1]) |> List.first() == 2_465_411_646
    end
  end

  describe "part 2: running the BOOST program" do
    test "running the program" do
      assert @program |> IntcodeV9.compute_result([2]) |> List.first() == 69781
    end
  end
end
