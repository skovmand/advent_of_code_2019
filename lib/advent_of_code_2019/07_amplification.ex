defmodule AdventOfCode2019.Amplification do
  @moduledoc """
  Send more power to the thrusters to reach Santa in time!
  """

  import AdventOfCode2019.IntCode.V5, only: [compute_result: 2]

  @doc """
  Find the optimum phase for amplifier output given a program
  """
  def optimum_phase(program) do
    all_phase_combinations()
    |> Enum.map(&run(program, &1))
    |> Enum.max()
  end

  @doc """
  Run the program on the amplifiers for a given phase combination
  """
  def run(program, phase_combination) do
    phase_combination
    |> Enum.reduce([0], fn phase, input_signal -> compute_result(program, [phase | input_signal]) end)
    |> List.first()
  end

  # All 120 possible phases for the amplifiers
  defp all_phase_combinations() do
    for a <- 0..4,
        b <- 0..4,
        c <- 0..4,
        d <- 0..4,
        e <- 0..4,
        a not in [b, c, d, e],
        b not in [a, c, d, e],
        c not in [a, b, d, e],
        d not in [a, b, c, e],
        do: [a, b, c, d, e]
  end
end
