defmodule Advent19.PasswordTest do
  use ExUnit.Case, async: true

  alias Advent19.Password

  describe "part 1: password combinations" do
    test "111111" do
      assert Password.is_candidate?(111_111, :basic) == true
    end

    test "223450" do
      assert Password.is_candidate?(223_450, :basic) == false
    end

    test "123789" do
      assert Password.is_candidate?(123_789, :basic) == false
    end

    test "solving the puzzle" do
      assert Password.find_candidates(172_930, 683_082, :basic) == 1675
    end
  end

  describe "part 2: additional rule" do
    test "112233" do
      assert Password.is_candidate?(112_233, :extended) == true
    end

    test "123444" do
      assert Password.is_candidate?(123_444, :extended) == false
    end

    test "111122" do
      assert Password.is_candidate?(111_122, :extended) == true
    end

    test "adding an additional rule" do
      assert Password.find_candidates(172_930, 683_082, :extended) == 1142
    end
  end
end
