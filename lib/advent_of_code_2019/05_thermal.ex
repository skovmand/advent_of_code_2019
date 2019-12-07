defmodule AdventOfCode2019.Thermal do
  @moduledoc """
  Day 5 of Advent of Code 2019: Adding the Thermal Environment Supervision Terminal
  """

  @doc """
  Computes a program, returning the first number as result
  """
  def compute_result(program, input) do
    program |> compute(input, [])
  end

  @doc """
  Compute a program, returning the program output
  """
  def compute(program, input, output, instruction_pointer \\ 0) do
    program
    |> Enum.drop(instruction_pointer)
    |> parse_first_opcode()
    |> do_compute(program, input, output, instruction_pointer)
  end

  @doc """
  Parse the first instruction into a tuple with opcode and modes
  We get the opcode by using modulo 100
  Then removing that part using floor division with 100, passing the result into position params
  """
  def parse_first_opcode(remaining_program) do
    remaining_program
    |> List.update_at(0, fn opcode -> 
      [opcode |> rem(100) | opcode |> div(100) |> position_params()] |> List.to_tuple()
    end)
  end

  # Parse an integer as position parameters, note the first element in the list is parameter 1 mode
  # but the digit used for parameter one mode is the right-most
  defp position_params(params) do
    [params |> rem(10), params |> rem(100) |> div(10), params |> div(100)]
    |> Enum.map(fn
      0 -> :pos
      1 -> :imm
    end)
  end

  # Do addition or multiplication for commands 1 and 2
  defp do_compute([{opcode, p1m, p2m, _p3m}, p1, p2, update_pos | _tail], program, input, output, instruction_pointer)
       when opcode in [1, 2] do
    left = if(p1m == :imm, do: p1, else: Enum.at(program, p1))
    right = if(p2m == :imm, do: p2, else: Enum.at(program, p2))

    program
    |> List.update_at(update_pos, fn _ -> calculate_opcode(opcode, left, right) end)
    |> compute(input, output, instruction_pointer + 4)
  end

  defp do_compute([{3, _, _, _}, update_pos | _tail], program, input, output, instruction_pointer) do
    {opcode_input, input} = input |> List.pop_at(0)

    program
    |> List.update_at(update_pos, fn _ -> opcode_input end)
    |> compute(input, output, instruction_pointer + 2)
  end

  defp do_compute([{4, p1m, _, _}, p1 | _tail], program, input, output, instruction_pointer) do
    output_value = if(p1m == :imm, do: p1, else: Enum.at(program, p1))
    output = [output_value | output]

    program
    |> compute(input, output, instruction_pointer + 2)
  end

  # Halt the program on opcode 99, returning the program
  defp do_compute([{99, _, _, _} | _], _program, _input, output, _instruction_count), do: output |> Enum.reverse()

  # Matches for calculation opcodes
  defp calculate_opcode(1, left, right), do: left + right
  defp calculate_opcode(2, left, right), do: left * right
end