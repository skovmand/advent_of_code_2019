defmodule AdventOfCode2019.PasswordTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2019.Password

  describe "part 1: password combinations" do
    test "111111" do
      assert Password.is_password_candidate?(111111) == true
    end

    test "223450" do
      assert Password.is_password_candidate?(223450) == false
    end

    test "123789" do
      assert Password.is_password_candidate?(123789) == false
    end

    test "solving the puzzle" do
      assert Password.find_candidates(172930, 683082) == 1675
    end
  end
end
