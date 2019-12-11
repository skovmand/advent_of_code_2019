defmodule Advent19.VectorsTest do
  use ExUnit.Case, async: true

  alias Advent19.Vectors

  test "creating vectors" do
    assert Vectors.from({0, 0}, {7, 2}) == {7, 2}
    assert Vectors.from({-5, -3}, {1, 1}) == {6, 4}
    assert Vectors.from({1, 1}, {-5, 3}) == {-6, 2}
  end

  test "the dot product of two vectors" do
    assert Vectors.dot_product({1, 1}, {6, 9}) == 15
    assert Vectors.dot_product({1, 0}, {4, 6}) == 4
    assert Vectors.dot_product({3, 6, 9}, {15, 29, 13}) == 336
  end

  test "vector length" do
    assert Vectors.vector_length({1, 1}) == 1.4142135623730951
    assert Vectors.vector_length({10, 3}) == 10.44030650891055
  end

  describe "vector angles" do
    test "angle between horizontal vectors" do
      assert Vectors.vector_angle({1, 0}, {1, 0}) == 0
      assert Vectors.vector_angle({1, 0}, {-1, 0}) == :math.pi()
    end

    test "angle between horizontal and vertical" do
      assert Vectors.vector_angle({1, 0}, {0, 1}) == 0.5 * :math.pi()
      assert Vectors.vector_angle({1, 0}, {0, -1}) == 1.5 * :math.pi()
    end

    test "vector angles from 0 to 2pi" do
      # vector with 0 < angle < pi/2
      assert Vectors.vector_angle({1, 0}, {4, 6}) == 0.982793723247329

      # vector with pi/2 < angle < pi
      assert Vectors.vector_angle({1, 0}, {-7, 3}) == 2.7367008673047097

      # vector with pi < angle < 3/2pi
      assert Vectors.vector_angle({1, 0}, {-4, -6}) == 4.124386376837122

      # vector with 3/2pi < angle < 2pi
      assert Vectors.vector_angle({1, 0}, {4, -6}) == 5.3003915839322575
    end
  end
end
