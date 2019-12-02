defmodule AdventOfCode2019.Opcode do
  @moduledoc """
  Day 2 of Advent of Code 2019: Building a new Intcode computer and completing the gravity assist around the Moon
  """

  @doc """
  Computes a program, returning the first number as result
  """
  def compute_result(program, pos_1, pos_2) do
    program |> initialize_program(pos_1, pos_2) |> compute() |> Enum.at(0)
  end

  @doc """
  Initialize the program by replacing values at position 1 and 2
  """
  def initialize_program(program, pos_1, pos_2) do
    program
    |> List.update_at(1, fn _ -> pos_1 end)
    |> List.update_at(2, fn _ -> pos_2 end)
  end

  @doc """
  Compute a program, returning the program
  """
  def compute(program, instruction_count \\ 0) do
    program
    |> Enum.drop(instruction_count * 4)
    |> Enum.take(4)
    |> do_compute(program, instruction_count)
  end

  # Halt the program on opcode 99, returning the program
  defp do_compute([99 | _tail], program, _instruction_count), do: program

  # Do addition or multiplication for commands 1 and 2
  defp do_compute([opcode, left, right, update_pos], program, instruction_count) when opcode in [1, 2] do
    left = Enum.at(program, left)
    right = Enum.at(program, right)

    program
    |> List.update_at(update_pos, fn _ -> calculate_opcode(opcode, left, right) end)
    |> compute(instruction_count + 1)
  end

  defp calculate_opcode(1, left, right), do: left + right
  defp calculate_opcode(2, left, right), do: left * right

  @doc """
  Compute inputs needed to produce 19690720
  """
  def brute_force_inputs(program) do
    for(a <- 0..99, b <- 0..99, do: {a, b})
    |> Stream.map(fn {a, b} -> {{a, b}, program |> compute_result(a, b)} end)
    |> Enum.find(fn {{_a, _b}, result} -> result == 19_690_720 end)
    |> elem(0)
  end
end
