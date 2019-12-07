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
end
