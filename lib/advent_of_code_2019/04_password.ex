defmodule AdventOfCode2019.Password do
  @doc """
  """
  def find_candidates(from, to) do
    from..to
    |> Enum.filter(&is_password_candidate?/1)
    |> Enum.count()
  end

  @doc """
  Test if a number is a password candidate
  """
  def is_password_candidate?(number) do
    number |> number_to_digit_list() |> digit_list_is_password?()
  end

  def number_to_digit_list(number) when number >= 100_000 and number < 1_000_000 do
    digit_1 = number |> div(100_000)
    digit_2 = number |> rem(100_000) |> div(10_000)
    digit_3 = number |> rem(10_000) |> div(1_000)
    digit_4 = number |> rem(1_000) |> div(100)
    digit_5 = number |> rem(100) |> div(10)
    digit_6 = number |> rem(10)

    [digit_1, digit_2, digit_3, digit_4, digit_5, digit_6]
  end

  @doc """
  Test if a list of 6 digits is a password
  """
  def digit_list_is_password?(digit_list) when is_list(digit_list),
    do: increasing?(digit_list) and two_identical?(digit_list)

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
end
