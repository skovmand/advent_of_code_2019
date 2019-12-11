defmodule Advent19.AsteroidsTest do
  use ExUnit.Case, async: true

  alias Advent19.Asteroids

  @field "input_10_asteroids.txt"
         |> Path.expand("./input_files")
         |> File.read!()

  describe "part 1" do
    test "first example" do
      field = """
      .#..#
      .....
      #####
      ....#
      ...##
      """

      assert field |> Asteroids.find_best_station() == {{3, 4}, 8}
    end

    test "second example" do
      field = """
      ......#.#.
      #..#.#....
      ..#######.
      .#.#.###..
      .#..#.....
      ..#....#.#
      #..#....#.
      .##.#..###
      ##...#..#.
      .#....####
      """

      assert field |> Asteroids.find_best_station() == {{5, 8}, 33}
    end

    test "third example" do
      field = """
      #.#...#.#.
      .###....#.
      .#....#...
      ##.#.#.#.#
      ....#.#.#.
      .##..###.#
      ..#...##..
      ..##....##
      ......#...
      .####.###.
      """

      assert field |> Asteroids.find_best_station() == {{1, 2}, 35}
    end

    test "fourth example" do
      field = """
      .#..#..###
      ####.###.#
      ....###.#.
      ..###.##.#
      ##.##.#.#.
      ....###..#
      ..#.#..#.#
      #..#.#.###
      .##...##.#
      .....#.#..
      """

      assert field |> Asteroids.find_best_station() == {{6, 3}, 41}
    end

    test "fifth example" do
      field = """
      .#..##.###...#######
      ##.############..##.
      .#.######.########.#
      .###.#######.####.#.
      #####.##.#.##.###.##
      ..#####..#.#########
      ####################
      #.####....###.#.#.##
      ##.#################
      #####.##.###..####..
      ..######..##.#######
      ####.##.####...##..#
      .#####..#.######.###
      ##...#.##########...
      #.##########.#######
      .####.#.###.###.#.##
      ....##.##.###..#####
      .#.#.###########.###
      #.#.#.#####.####.###
      ###.##.####.##.#..##
      """

      assert field |> Asteroids.find_best_station() == {{11, 13}, 210}
    end

    test "day 10 part 1 answer" do
      assert @field |> Asteroids.find_best_station() == {{26, 29}, 299}
    end
  end
end
