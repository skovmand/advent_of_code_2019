defmodule AdventOfCode2019.Password do
  @moduledoc """
  Advent of Code 2019 day 4: Finding candidates for the forgotten password
  """

  @doc """
  Find password candidates in a given range
  """
  def find_candidates(from, to, :basic) do
    do_find_candidates(from, to, &digit_list_is_password?/1)
  end

  def find_candidates(from, to, :extended) do
    do_find_candidates(from, to, &digit_list_is_password_extended?/1)
  end

  defp do_find_candidates(from, to, candidate_fn) do
    from..to
    |> Enum.map(&number_to_digit_list/1)
    |> Enum.filter(candidate_fn)
    |> Enum.count()
  end

  @doc """
  Check whether a single password is a candidate
  """
  def is_candidate?(number, :basic) do
    number |> number_to_digit_list() |> digit_list_is_password?()
  end

  def is_candidate?(number, :extended) do
    number |> number_to_digit_list() |> digit_list_is_password_extended?()
  end

  @doc """
  Test if a list of 6 digits is a password
  """
  def digit_list_is_password?(digit_list) when is_list(digit_list),
    do: increasing?(digit_list) and two_identical?(digit_list)

  @doc """
  Test if a list of 6 digits is a password
  """
  def digit_list_is_password_extended?(digit_list) when is_list(digit_list),
    do: increasing?(digit_list) and match_extended_criteria?(digit_list)

  @doc """
  Test whether a list of numbers is never decreasing
  """
  def increasing?([first_number, second_number | tail]) when second_number >= first_number,
    do: increasing?([second_number | tail])

  def increasing?([first_number, second_number | _tail]) when second_number < first_number, do: false
  def increasing?([_ | []]), do: true

  @doc """
  Test whether a list of SIX numbers has two identical numbers
  """
  def two_identical?([a, a, _, _, _, _]), do: true
  def two_identical?([_, b, b, _, _, _]), do: true
  def two_identical?([_, _, c, c, _, _]), do: true
  def two_identical?([_, _, _, d, d, _]), do: true
  def two_identical?([_, _, _, _, e, e]), do: true
  def two_identical?(_), do: false

  @doc """
  Check that two adjacent characters are not part of a larger group
  Yeah, I know - this got out of hand :-)
  """
  def match_extended_criteria?([a, a, a, a, a, a]), do: false

  def match_extended_criteria?([a, a, a, a, a, b]) when a != b, do: false
  def match_extended_criteria?([b, a, a, a, a, a]) when a != b, do: false

  def match_extended_criteria?([b, a, a, a, a, b]) when a != b, do: false
  def match_extended_criteria?([b, b, a, a, a, a]) when a != b, do: true
  def match_extended_criteria?([a, a, a, a, b, b]) when a != b, do: true

  def match_extended_criteria?([a, a, a, b, b, c]) when a != b and b != c, do: true
  def match_extended_criteria?([a, a, a, c, b, b]) when a != b and b != c, do: true
  def match_extended_criteria?([c, a, a, a, b, b]) when a != b and b != c, do: true
  def match_extended_criteria?([b, b, a, a, a, c]) when a != b and b != c, do: true
  def match_extended_criteria?([b, b, c, a, a, a]) when a != b and b != c, do: true
  def match_extended_criteria?([c, b, b, a, a, a]) when a != b and b != c, do: true

  def match_extended_criteria?([a, a, b, c, d, e]) when a not in [b, c, d, e], do: true
  def match_extended_criteria?([a, b, b, c, d, e]) when b not in [a, c, d, e], do: true
  def match_extended_criteria?([a, b, c, c, d, e]) when c not in [a, b, d, e], do: true
  def match_extended_criteria?([a, b, c, d, d, e]) when d not in [a, b, c, e], do: true
  def match_extended_criteria?([a, b, c, d, e, e]) when e not in [a, b, c, d], do: true

  def match_extended_criteria?(_), do: false

  # Converts a number into a list of its digits
  defp number_to_digit_list(number) when number >= 100_000 and number < 1_000_000 do
    digit_1 = number |> div(100_000)
    digit_2 = number |> rem(100_000) |> div(10_000)
    digit_3 = number |> rem(10_000) |> div(1_000)
    digit_4 = number |> rem(1_000) |> div(100)
    digit_5 = number |> rem(100) |> div(10)
    digit_6 = number |> rem(10)

    [digit_1, digit_2, digit_3, digit_4, digit_5, digit_6]
  end
end
