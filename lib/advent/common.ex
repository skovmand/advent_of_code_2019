defmodule Advent19.Common do
  @moduledoc """
  Common functions for Advent of Code 2019
  """

  @doc """
  Convert a line separated strings into a list of strings
  """
  def string_list(input) do
    input
    |> String.split("\n", trim: true)
  end

  @doc """
  Convert a string of comma separated integers into a list of integers
  """
  def integer_list(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Convert a string of single digits into a list of those digits
  """
  def single_digit_list(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Convert multiple strings to coordinates
  """
  def coordinates(input) do
    input
    |> string_list()
    |> Enum.map(&string_to_coordinates/1)
  end

  @doc """
  Convert the input format <x=-1, y=0, z=2> into a 3-tuple

  iex> "<x=-1, y=0, z=2>" |> Common.string_to_coordinates()
  {-1, 0, 2}

  iex> "<x=-1, y=  0, z= 2>" |> Common.string_to_coordinates()
  {-1, 0, 2}
  """
  def string_to_coordinates(input) do
    Regex.run(~r/<x=\s*(-?\d*),\s*y=\s*(-?\d*),\s*z=\s*(-?\d*)>/, input)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
