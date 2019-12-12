defmodule Advent19.Intcode.Runtime do
  @moduledoc """
  General Intcode Runtime with all intcode features
  """

  defmodule Execution do
    @moduledoc """
    The execution holds information about the program, 
    the current instruction pointer, the input and output.
    """

    defstruct memory: [], pointer: 0, input: [], output: [], relative_base: 0

    def read_program_into_memory(program) do
      program
      |> Enum.with_index()
      |> Enum.into(%{}, fn {instruction, position} -> {position, instruction} end)
    end
  end

  @doc """
  Computes a program, returning the first number as result
  """
  def run(%Execution{} = execution) do
    execution
    |> read_next_instruction_and_parameters()
    |> do_compute(execution)
  end

  defp read_next_instruction_and_parameters(%Execution{memory: memory, pointer: pointer}) do
    opcode_and_param_modes = memory |> Map.fetch!(pointer) |> parse_opcode_and_position_params()

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
        (pointer + 1)..(pointer + parameter_count) |> Enum.map(&Map.fetch!(memory, &1))
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
  defp do_compute([{opcode, p1m, p2m, p3m}, p1, p2, p3], %Execution{memory: memory} = execution)
       when opcode in [1, 2, 7, 8] do
    left = memory |> get_parameter(p1, p1m, execution.relative_base)
    right = memory |> get_parameter(p2, p2m, execution.relative_base)
    update_pos = if(p3m == :rel, do: execution.relative_base + p3, else: p3)

    result = calculate_opcode(opcode, left, right)

    execution
    |> Map.update!(:memory, fn memory -> memory |> Map.put(update_pos, result) end)
    |> Map.update!(:pointer, fn pointer -> pointer + 4 end)
    |> run()
  end

  # Opcode 3: Read from input
  # If no input is present in the input list, halt the program and wait for input
  defp do_compute([{3, p1m, _, _}, p1], %Execution{input: input} = execution) do
    update_pos = if(p1m == :rel, do: execution.relative_base + p1, else: p1)

    case input do
      [] ->
        # Return waiting for input signal, and the same pointer to repeat 
        # this operation again when input is available
        {:waiting_for_input, execution}

      [input | remaining_input] ->
        execution
        |> Map.put(:input, remaining_input)
        |> Map.update!(:memory, fn memory -> memory |> Map.put(update_pos, input) end)
        |> Map.update!(:pointer, fn pointer -> pointer + 2 end)
        |> run()
    end
  end

  # Opcode 4: Write to output
  # Halt the program with an output and the current execution state
  defp do_compute([{4, p1m, _, _}, p1], %Execution{memory: memory} = execution) do
    output_value = memory |> get_parameter(p1, p1m, execution.relative_base)

    {:output, output_value, execution |> Map.update!(:pointer, fn pointer -> pointer + 2 end)}
  end

  # Opcode 5,6: Jump if true/false
  defp do_compute([{opcode, p1m, p2m, _}, p1, p2], %Execution{memory: memory, pointer: pointer} = execution)
       when opcode in [5, 6] do
    boolean = memory |> get_parameter(p1, p1m, execution.relative_base)
    pointer_if_true = memory |> get_parameter(p2, p2m, execution.relative_base)

    execution
    |> Map.put(:pointer, compare_opcode(opcode, boolean, pointer_if_true, pointer + 3))
    |> run()
  end

  # Opcode 9: Set new relative base
  defp do_compute([{9, p1m, _, _}, p1], %Execution{memory: memory} = execution) do
    offset = memory |> get_parameter(p1, p1m, execution.relative_base)

    execution
    |> Map.update!(:relative_base, fn relative_base -> relative_base + offset end)
    |> Map.update!(:pointer, fn pointer -> pointer + 2 end)
    |> run()
  end

  # Opcode 99: Halt and return the execution
  defp do_compute([{99, _, _, _}], %Execution{} = execution) do
    {:halt, execution}
  end

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
