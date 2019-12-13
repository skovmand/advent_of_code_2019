defmodule Advent19.Opcode do
  @moduledoc """
  Day 2 of Advent of Code 2019: Building a new Intcode computer and completing the gravity assist around the Moon.
  The question uses the general intcode runtime.
  """

  alias Advent19.Intcode.Runner
  alias Advent19.Intcode.Runtime.Execution

  @doc """
  Computes a program, returning the first number as result
  Noun replaces the program element at position 1
  Verb replaces the program element at position 2
  """
  def compute_result(program, noun, verb) do
    halt_handler = fn %Execution{memory: memory} -> memory |> Map.get(0) end

    program
    |> initialize_program(noun, verb)
    |> Runner.start(break_handlers: %{halt: halt_handler})
  end

  @doc """
  Initialize the program by replacing values at position 1 and 2
  """
  def initialize_program(program, noun, verb) do
    program
    |> List.update_at(1, fn _ -> noun end)
    |> List.update_at(2, fn _ -> verb end)
  end

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
