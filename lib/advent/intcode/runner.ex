defmodule Advent19.Intcode.Runner do
  @moduledoc """
  Runner for Intcode programs: 
  Initializes the program and provides program break handlers
  """

  alias Advent19.Intcode.Runtime
  alias Advent19.Intcode.Runtime.Execution

  @doc """
  Start a program, with ability to specify break handlers :input, :output and :halt.
  If a break handler is not set, the default break handler will be used.
  """
  def start_program(program, opts \\ []) do
    input = Keyword.get(opts, :input, [])
    break_handlers = Keyword.get(opts, :break_handlers, %{})

    %Execution{
      memory: program |> Execution.read_program_into_memory(),
      input: input |> List.wrap(),
      handlers: break_handlers
    }
    |> run()
  end

  # The initial function of the execution loop
  defp run(%Execution{} = execution) do
    Runtime.run(execution) |> parse_program_break()
  end

  # Handle input with a custom input handler
  defp parse_program_break({:waiting_for_input, %Execution{handlers: %{input: input_fn}} = execution}) do
    execution |> input_fn.() |> run()
  end

  # Default input handler
  defp parse_program_break({:waiting_for_input, _execution}) do
    raise "Program wants input, but none is available"
  end

  # Handle output with a custom output handler
  defp parse_program_break({:output, output_value, %Execution{handlers: %{output: output_fn}} = execution}) do
    execution |> output_fn.(output_value) |> run()
  end

  # Default output handler
  defp parse_program_break({:output, output_value, %Execution{} = execution}) do
    execution |> Map.update!(:output, fn output -> [output_value | output] end) |> run()
  end

  # Handle halt with custom halt handler
  defp parse_program_break({:halt, %Execution{handlers: %{halt: halt_fn}} = execution}) do
    execution |> halt_fn.()
  end

  # Default halt handler
  defp parse_program_break({:halt, %Execution{output: output}}) do
    output
    |> case do
      [element] -> element
      other -> other
    end
  end
end
