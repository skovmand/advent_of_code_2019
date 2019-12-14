defmodule Advent19.Intcode.Runner do
  @moduledoc """
  Runner for Intcode programs: 
  Initializes the program and provides program break handlers
  """

  alias Advent19.Intcode.Runtime
  alias Advent19.Intcode.Runtime.Execution

  @doc """
  Initialize and start a program (convenience function)
  """
  def start(program, opts \\ []), do: init(program, opts) |> run()

  @doc """
  Initialize a program
  """
  def init(program, opts \\ []) do
    input = Keyword.get(opts, :input, [])
    output = Keyword.get(opts, :output, [])
    break_handlers = Keyword.get(opts, :break_handlers, %{})

    %Execution{
      memory: program |> Execution.read_program_into_memory(),
      input: input |> List.wrap(),
      output: output,
      handlers: break_handlers
    }
  end

  @doc """
  Run a program
  """
  def run(%Execution{} = execution) do
    Runtime.run(execution) |> parse_program_break()
  end

  # Handle input with a custom input handler
  defp parse_program_break({:waiting_for_input, %Execution{handlers: %{input: input_fn}} = execution}) do
    execution |> input_fn.()
  end

  # Default input handler
  defp parse_program_break({:waiting_for_input, _execution}) do
    raise "Program wants input, but none is available"
  end

  # Handle output with a custom output handler
  defp parse_program_break({:output, output_value, %Execution{handlers: %{output: output_fn}} = execution}) do
    # A continuation function will be passed as callback for the output handler
    continue_fn = fn %Execution{} = execution -> run(execution) end

    execution |> output_fn.(output_value, continue_fn)
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
    output |> Enum.reverse()
  end
end
