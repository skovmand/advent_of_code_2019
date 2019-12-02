defmodule AdventOfCode2019.FuelRequirements do
  @moduledoc """
  Advent of Code 2019, Day 1
  """

  @doc """
  Calculate fuel needed to lift a list of payload masses
  """
  def mass_list_to_fuel(mass_list) do
    mass_list
    |> Enum.map(&mass_to_fuel/1)
    |> Enum.sum()
  end

  @doc """
  Calculate the total fuel needed to lift a list of payload masses,
  including the fuel needed to lift the fuel
  """
  def mass_list_to_total_fuel(mass_list) do
    mass_list
    |> Enum.map(&mass_to_total_fuel/1)
    |> Enum.sum()
  end

  @doc """
  Calculate needed fuel mass to lift a payload mass
  Does not account for the extra needed fuel to lift the fuel
  """
  def mass_to_fuel(mass) do
    mass
    |> Kernel.div(3)
    |> Kernel.-(2)
  end

  @doc """
  Calculate the needed fuel mass required to lift a payload,
  including the fuel needed to lift the extra fuel
  """
  def mass_to_total_fuel(mass), do: calculate_total_fuel(mass, 0)

  defp calculate_total_fuel(mass, total_fuel) do
    fuel_for_mass = mass |> mass_to_fuel()

    if fuel_for_mass <= 0 do
      total_fuel
    else
      calculate_total_fuel(fuel_for_mass, total_fuel + fuel_for_mass)
    end
  end
end
