defmodule Advent19.Amplification do
  @moduledoc """
  Send more power to the thrusters to reach Santa in time!
  """

  alias Advent19.Intcode.Runner
  alias Advent19.Intcode.Runtime.Execution

  @doc """
  Part 1

  Find the optimum phase for amplifier output given a program by running all five amplifiers
  in sequence, feeding 0 as input to the first amp, then connecting outputs and inputs on the
  following amps. In practice it just runs the same program 5 times with the output of the former
  as input to the next.
  """
  def optimum_phase(program) do
    all_phase_combinations(0..4)
    |> Enum.map(fn phase_combination -> run_serial(program, phase_combination) end)
    |> Enum.max()
  end

  @doc """
  Run a program with serially connected amps to get the output to thrusters

      O-------O  O-------O  O-------O  O-------O  O-------O
  0 ->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-> (to thrusters)
      O-------O  O-------O  O-------O  O-------O  O-------O
  """
  def run_serial(program, phase_combination) do
    phase_combination
    |> Enum.reduce([0], fn phase, input_signal -> Runner.start(program, input: [phase | input_signal]) end)
    |> List.first()
  end

  @doc """
  Part 2

  Find the optimum phase for the feedback loop amplifier configuration. This needs a reconfigured
  Intcode computer that returns on every output (opcode 4) with the output and the current instruction
  pointer. We need to keep track of the instruction pointers for each amp.
  """
  def optimum_feedback_loop_phase(program) do
    all_phase_combinations(5..9)
    |> Enum.map(fn phase_combination -> run_feedback(program, phase_combination) end)
    |> Enum.max()
  end

  @doc """
  Run a program with amps in feedback loop to get output to thrusters

        O-------O  O-------O  O-------O  O-------O  O-------O
  0 -+->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-.
     |  O-------O  O-------O  O-------O  O-------O  O-------O |
     |                                                        |
     '--------------------------------------------------------+
                                                              |
                                                              v
                                                       (to thrusters)
  """
  def run_feedback(program, phase_combination) do
    # Output handler: Breaks the program, outputting the output value and the execution for storing it
    output_handler = fn %Execution{} = execution, output_value, _ ->
      {:output, output_value, execution}
    end

    # Halt handler: Just outputs :halt, nothing else
    halt_handler = fn _ -> :halt end

    # Set up the initial executions
    amp_executions = init_executions(program, phase_combination, %{output: output_handler, halt: halt_handler})

    # The count of amps is the length of the phase combination, counting from 0
    amp_count = (phase_combination |> Enum.count()) - 1

    Stream.cycle(0..amp_count)
    |> Enum.reduce_while(amp_executions, fn amp_number, amp_executions ->
      case Runner.run(amp_executions |> Map.fetch!(amp_number)) do
        {:output, output_value, execution_snapshot} ->
          next_amp_number = rem(amp_number + 1, amp_count + 1)

          updated_amp_executions =
            amp_executions
            |> Map.put(amp_number, execution_snapshot)
            |> Map.update!(amp_number, fn execution -> execution |> Map.put(:output, output_value) end)
            |> Map.update!(next_amp_number, fn execution ->
              execution |> Map.update!(:input, fn input -> [output_value | input] |> Enum.reverse() end)
            end)

          {:cont, updated_amp_executions}

        :halt ->
          {:halt, amp_executions |> Map.fetch!(amp_count) |> Map.fetch!(:output)}
      end
    end)
  end

  # Create an Execution struct for each amp
  defp init_executions(program, phase_combination, handlers) do
    initial_input(phase_combination)
    |> Enum.into(%{}, fn {amp_number, initial_input} ->
      {amp_number, Runner.init(program, input: initial_input, break_handlers: handlers)}
    end)
  end

  # Create a map of amp => initial_input from a given phase combination
  # Each amp is fed its phase as initial input, except the first amp which also recieves 0 as second input
  defp initial_input(phase_combination) do
    phase_combination
    |> List.update_at(0, fn phase -> [phase | [0]] end)
    |> Enum.map(&List.wrap/1)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end

  # All 120 possible phases for the amplifiers
  defp all_phase_combinations(range) do
    for a <- range,
        b <- range,
        c <- range,
        d <- range,
        e <- range,
        a not in [b, c, d, e],
        b not in [a, c, d, e],
        c not in [a, b, d, e],
        d not in [a, b, c, e],
        do: [a, b, c, d, e]
  end
end
