defmodule Advent19.Amplification do
  @moduledoc """
  Send more power to the thrusters to reach Santa in time!
  """

  alias Advent19.Intcode.Runner
  alias Advent19.IntcodeV7

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
    |> Enum.reduce([0], fn phase, input_signal -> Runner.start_program(program, input: [phase | input_signal]) end)
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
    initial_input = phase_combination |> initial_input()

    Stream.cycle(0..4)
    |> Enum.reduce_while({initial_input, [], %{}}, fn amp, {initial_inputs, next_input, memory_dump} ->
      {amp_input, initial_inputs} =
        case Map.fetch(initial_inputs, amp) do
          :error -> {next_input, initial_inputs}
          {:ok, initial_input} -> {initial_input ++ next_input, initial_inputs |> Map.delete(amp)}
        end

      {next_instruction_pointer, amp_program, _} = Map.get(memory_dump, amp, {0, program, []})

      case IntcodeV7.compute(amp_program, amp_input, [], next_instruction_pointer) do
        {:halt, _} ->
          {:halt, memory_dump |> last_value_from_amp_e()}

        {:output, output, {next_instruction, program}} ->
          {:cont, {initial_inputs, output, memory_dump |> Map.put(amp, {next_instruction, program, output})}}
      end
    end)
  end

  # Create a map of amp => initial_input from a given phase combination
  defp initial_input(phase_combination) do
    phase_combination
    |> Enum.map(&[&1])
    |> List.update_at(0, &(&1 ++ [0]))
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end

  # When the program ends, we fetch the last output from amp E ("4" in our memory dump map)
  defp last_value_from_amp_e(%{4 => {_, _, [value]}}), do: value

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
