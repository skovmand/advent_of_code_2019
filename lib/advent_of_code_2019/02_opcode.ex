defmodule AdventOfCode2019.Opcode do
  @moduledoc """
  Day 2 of Advent of Code 2019: Building a new Intcode computer!
  """

  @doc """
  Compute a program
  """
  def compute(program, instruction_count \\ 0) do
    program
    |> Enum.drop(instruction_count * 4)
    |> Enum.take(4)
    |> do_compute(program, instruction_count)
  end

  # Halt the program on opcode 99
  defp do_compute([99 | _tail], program, _instruction_count), do: program

  # Do addition or multiplication for commands 1 and 2
  defp do_compute([opcode, pos_left, pos_right, update_pos], program, instruction_count) when opcode in [1, 2] do
    left = Enum.at(program, pos_left)
    right = Enum.at(program, pos_right)

    program
    |> List.update_at(update_pos, fn _ -> calculate_opcode(opcode, left, right) end)
    |> compute(instruction_count + 1)
  end

  def calculate_opcode(1, left, right), do: left + right
  def calculate_opcode(2, left, right), do: left * right
end
