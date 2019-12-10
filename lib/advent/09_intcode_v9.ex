defmodule Advent19.IntcodeV9 do
  @moduledoc """
  Day 9 of Advent of Code 2019: Adding support for relative parameters
  And rewriting the memory of the computer into a map to support accessing memory beyond the program
  """

  @doc """
  Computes a program, returning the first number as result
  """
  def compute_result(program, input) do
    program
    |> read_into_memory()
    |> compute(input, [])
  end

  # Reads the whole program into a map of position => value
  defp read_into_memory(program) do
    program
    |> Enum.with_index()
    |> Enum.into(%{}, fn {instruction, position} -> {position, instruction} end)
  end

  @doc """
  Compute a program, returning the program output
  """
  def compute(program, input, output, instruction_pointer \\ 0, relative_base \\ 0) do
    program
    |> read_next_instruction_and_parameters(instruction_pointer)
    |> do_compute(program, input, output, instruction_pointer, relative_base)
  end

  defp read_next_instruction_and_parameters(program, instruction_pointer) do
    opcode_and_param_modes =
      program
      |> Map.fetch!(instruction_pointer)
      |> parse_opcode_and_position_params()

    # The required parameters
    parameter_count =
      case opcode_and_param_modes do
        {i, _, _, _} when i in [1, 2, 7, 8] -> 3
        {i, _, _, _} when i in [3, 4, 9] -> 1
        {i, _, _, _} when i in [5, 6] -> 2
        {99, _, _, _} -> 0
      end

    params =
      if parameter_count > 0 do
        (instruction_pointer + 1)..(instruction_pointer + parameter_count) |> Enum.map(&Map.fetch!(program, &1))
      else
        []
      end

    [opcode_and_param_modes | params]
  end

  @doc """
  Parse the first instruction into a tuple with opcode and modes. We get the opcode by using modulo 100..
  Then removing that part using floor division with 100, passing the result into position params
  """
  def parse_opcode_and_position_params(opcode) do
    [opcode |> rem(100) | opcode |> div(100) |> position_params()] |> List.to_tuple()
  end

  # Parse an integer as position parameters, note the first element in the list is parameter 1 mode
  # but the digit used for parameter one mode is the right-most
  defp position_params(params) do
    [params |> rem(10), params |> rem(100) |> div(10), params |> div(100)]
    |> Enum.map(fn
      0 -> :pos
      1 -> :imm
      2 -> :rel
    end)
  end

  # Implementation of parameter modes
  defp get_parameter(_program, param, :imm, _), do: param
  defp get_parameter(program, param, :pos, _), do: program |> Map.get(param, 0)
  defp get_parameter(program, param, :rel, relative_base), do: program |> Map.get(relative_base + param, 0)

  # Opcode 1,2,7,8: Calculations with two parameters overwriting a position
  defp do_compute([{opcode, p1m, p2m, p3m}, p1, p2, p3], program, input, output, instruction_pointer, rel_base)
       when opcode in [1, 2, 7, 8] do
    left = program |> get_parameter(p1, p1m, rel_base)
    right = program |> get_parameter(p2, p2m, rel_base)
    update_pos = if(p3m == :rel, do: rel_base + p3, else: p3)

    program
    |> Map.put(update_pos, calculate_opcode(opcode, left, right))
    |> compute(input, output, instruction_pointer + 4, rel_base)
  end

  # Opcode 3: Read from input
  defp do_compute([{3, p1m, _, _}, p1], program, input, output, instruction_pointer, rel_base) do
    {opcode_input, input} = input |> List.pop_at(0)
    update_pos = if(p1m == :rel, do: rel_base + p1, else: p1)

    program
    |> Map.put(update_pos, opcode_input)
    |> compute(input, output, instruction_pointer + 2, rel_base)
  end

  # Opcode 4: Write to output
  defp do_compute([{4, p1m, _, _}, p1], program, input, output, instruction_pointer, rel_base) do
    output_value = program |> get_parameter(p1, p1m, rel_base)
    output = [output_value | output]

    program
    |> compute(input, output, instruction_pointer + 2, rel_base)
  end

  # Opcode 5,6: Jump if true/false
  defp do_compute([{opcode, p1m, p2m, _}, p1, p2], program, input, output, instruction_pointer, rel_base)
       when opcode in [5, 6] do
    boolean = program |> get_parameter(p1, p1m, rel_base)
    instruction_pointer_if_true = program |> get_parameter(p2, p2m, rel_base)

    new_instruction_pointer = compare_opcode(opcode, boolean, instruction_pointer_if_true, instruction_pointer + 3)

    program |> compute(input, output, new_instruction_pointer, rel_base)
  end

  # Opcode 9: Set new relative base
  defp do_compute([{9, p1m, _, _}, p1], program, input, output, instruction_pointer, rel_base) do
    offset = program |> get_parameter(p1, p1m, rel_base)

    program |> compute(input, output, instruction_pointer + 2, rel_base + offset)
  end

  # Opcode 99: Halt and send output
  defp do_compute([{99, _, _, _} | _], _program, _input, output, _instruction_count, _rel_base),
    do: output |> Enum.reverse()

  # Matches for calculation opcodes
  defp calculate_opcode(1, left, right), do: left + right
  defp calculate_opcode(2, left, right), do: left * right

  # Matches for comparisons
  defp calculate_opcode(7, left, right) when left < right, do: 1
  defp calculate_opcode(7, _, _), do: 0
  defp calculate_opcode(8, left, right) when left == right, do: 1
  defp calculate_opcode(8, _, _), do: 0

  # Matches for jumps
  defp compare_opcode(5, 0, _pointer_if_true, pointer_if_false), do: pointer_if_false
  defp compare_opcode(5, _, pointer_if_true, _pointer_if_false), do: pointer_if_true

  defp compare_opcode(6, 0, pointer_if_true, _pointer_if_false), do: pointer_if_true
  defp compare_opcode(6, _, _pointer_if_true, pointer_if_false), do: pointer_if_false
end
