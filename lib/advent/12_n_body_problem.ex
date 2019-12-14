defmodule Advent19.NBodyProblem do
  @moduledoc """
  Calculating orbits in the space around Jupiter

  Time steps:
  -----------
  1. Update the velocity of every moon by applying gravity
  2. Update the position of every moon by applying velocity
  Time progresses by one step once all of the positions are updated.
  The velocity of each moon starts at 0

  Applying gravity:
  -----------------
  To apply gravity, consider every pair of moons
  On each axis (x, y, and z), the velocity of each moon changes by exactly +1 or -1 to pull the moons together.

  Applying velocity:
  ------------------
  Apply velocity: simply add the velocity of each moon to its own position
  This process does not modify the velocity of any moon
  """

  defmodule Moon do
    defstruct [:position, :velocity]

    @doc """
    Create a moon from position coordinates
    """
    def new({x, y, z}), do: %Moon{position: %{x: x, y: y, z: z}, velocity: %{x: 0, y: 0, z: 0}}

    def new({px, py, pz}, {vx, vy, vz}), do: %Moon{position: %{x: px, y: py, z: pz}, velocity: %{x: vx, y: vy, z: vz}}

    @doc """
    Calculate the total kinetic energy for a moon
    """
    def kinetic_energy(%Moon{position: pos, velocity: vel}) do
      (abs(pos.x) + abs(pos.y) + abs(pos.z)) * (abs(vel.x) + abs(vel.y) + abs(vel.z))
    end
  end

  # Find the greatest common divisor for two numbers
  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))

  # Find the least common multiple of a number
  defp lcm(a, b), do: div(abs(a * b), gcd(a, b))
  defp lcm(x, y, z), do: lcm(x, lcm(y, z))

  @doc """
  Calculate total kinetic energy after n steps given position coordinates OR given a list of moons
  This is entry point for question 1
  """
  def total_kinetic_energy(position_coordinates, steps) do
    position_coordinates
    |> init_moons()
    |> moon_state(steps)
    |> total_kinetic_energy()
  end

  @doc """
  Calculate total kinetic energy for a list of moons
  """
  def total_kinetic_energy(moons) do
    moons
    |> Enum.map(&Moon.kinetic_energy/1)
    |> Enum.sum()
  end

  @doc """
  Search for an identical moon state
  Entry point for question 2

  The idea here is to find the number of time cycles until x, y and z repeat
  individually. This can be done fairly quickly because the axis are independent
  of each other.

  Then we will find the least common multiple for the three numbers, which guarantees
  that the initial state will happen at that exact cycle.
  """
  def time_cycles_to_loop(moons) do
    initial_x = moons |> get_moon_coordinate(:x)
    initial_y = moons |> get_moon_coordinate(:y)
    initial_z = moons |> get_moon_coordinate(:z)

    x = moons |> find_identical_state_for(:x, initial_x)
    y = moons |> find_identical_state_for(:y, initial_y)
    z = moons |> find_identical_state_for(:z, initial_z)

    lcm(x, y, z)
  end

  # Find the first identical state for a list of coordinates
  defp find_identical_state_for(moons, coordinate, initial_state) do
    do_find_identical(moons, coordinate, initial_state, 1)
  end

  defp do_find_identical(moons, coordinate, initial_state, round) do
    updated_moons =
      moons
      |> apply_gravity()
      |> apply_velocity()

    this_state = updated_moons |> get_moon_coordinate(coordinate)

    if initial_state == this_state,
      do: round,
      else: do_find_identical(updated_moons, coordinate, initial_state, round + 1)
  end

  # Transform a list of moons into e.g. only its x coordinate for both position and velocity
  defp get_moon_coordinate(moons, coordinate) do
    moons
    |> Enum.flat_map(fn %Moon{position: position, velocity: velocity} ->
      [position |> Map.get(coordinate), velocity |> Map.get(coordinate)]
    end)
  end

  @doc """
  Calculate the moon states after n steps
  """
  def moon_state(moons, steps) do
    1..steps
    |> Enum.reduce(moons, fn _, moons ->
      moons
      |> apply_gravity()
      |> apply_velocity()
    end)
  end

  @doc """
  Initialize moons from a list of position coordinates
  """
  def init_moons(position_coordinates) do
    position_coordinates |> Enum.map(&Moon.new/1)
  end

  # Apply gravity for all moons
  defp apply_gravity(moons) do
    moons
    |> Enum.map(fn moon ->
      other_moons = List.delete(moons, moon)
      apply_gravity_for_moon(moon, other_moons)
    end)
  end

  # Apply gravity for a single moon given other moons
  defp apply_gravity_for_moon(moon, other_moons) do
    other_moons
    |> Enum.reduce(moon, fn other_moon, %Moon{position: position, velocity: velocity} = moon ->
      updated_velocity =
        velocity
        |> Map.put(:x, apply_gravity_for_coordinate(velocity.x, position.x, other_moon.position.x))
        |> Map.put(:y, apply_gravity_for_coordinate(velocity.y, position.y, other_moon.position.y))
        |> Map.put(:z, apply_gravity_for_coordinate(velocity.z, position.z, other_moon.position.z))

      moon |> Map.put(:velocity, updated_velocity)
    end)
  end

  defp apply_gravity_for_coordinate(moon_vel, moon_pos, other_moon_pos) do
    case compare(moon_pos, other_moon_pos) do
      :gt -> moon_vel - 1
      :eq -> moon_vel
      :lt -> moon_vel + 1
    end
  end

  # Apply velocity for all moons given their gravities
  defp apply_velocity(moons) do
    moons
    |> Enum.map(fn %Moon{position: position, velocity: velocity} = moon ->
      updated_position =
        position
        |> Map.put(:x, position.x + velocity.x)
        |> Map.put(:y, position.y + velocity.y)
        |> Map.put(:z, position.z + velocity.z)

      moon |> Map.put(:position, updated_position)
    end)
  end

  defp compare(a, b) when a > b, do: :gt
  defp compare(a, b) when a == b, do: :eq
  defp compare(a, b) when a < b, do: :lt
end
