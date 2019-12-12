defmodule Advent19.Boost do
  @moduledoc """
  Run the BOOST self-diagnostics and program
  """

  alias Advent19.Intcode.Runtime
  alias Advent19.Intcode.Runtime.Execution

  def start_program(program, input) do
    %Execution{
      memory: program |> Execution.read_program_into_memory(),
      input: input |> List.wrap()
    }
    |> run()
  end

  def run(%Execution{} = execution) do
    Runtime.run(execution)
    |> parse_program_break()
  end

  defp parse_program_break({:waiting_for_input, %Execution{} = _execution}) do
    raise "This shouldn't happen"
  end

  defp parse_program_break({:output, output_value, %Execution{} = execution}) do
    execution
    |> Map.update!(:output, fn output -> [output_value | output] end)
    |> run()
  end

  defp parse_program_break({:halt, %Execution{} = execution}) do
    execution |> Map.fetch!(:output) |> Enum.reverse()
  end
end
