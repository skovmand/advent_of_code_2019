defmodule Advent19.Paint do
  @moduledoc """
  Controlling the paint robot to paint our ship appropriately
  """

  alias Advent19.Intcode.Runner
  alias Advent19.Intcode.Runtime.Execution

  @doc """
  Paint the spaceship given the paint robot program
  """
  def paint_spaceship(program) do
    # The output handler outputs every second output value to the parent, with parsed values
    handle_output = fn %Execution{output: output} = execution, output_value, continue_fn ->
      case output do
        [] ->
          execution
          |> Map.put(:output, if(output_value == 0, do: [:black], else: [:white]))
          |> continue_fn.()

        [colour] ->
          {:output, {colour, if(output_value == 0, do: :left, else: :right)}, execution |> Map.put(:output, [])}
      end
    end

    # Just output :halt when done
    handle_halt = fn _ -> :halt end

    # Initialize the Execution
    execution = Runner.init(program, input: 0, break_handlers: %{output: handle_output, halt: handle_halt})

    do_paint_panels(%{}, {0, 0}, :up, execution)
  end

  defp do_paint_panels(panel_map, position, direction, execution) do
    Runner.run(execution) |> parse_output(panel_map, position, direction)
  end

  defp parse_output({:output, {color, movement}, execution}, panel_map, position, direction) do
    new_panel_map = panel_map |> Map.put(position, color)
    new_direction = new_direction(direction, movement)
    new_position = new_position(position, new_direction)

    color_at_new_position =
      new_panel_map
      |> Map.get(new_position, :black)
      |> case do
        :black -> 0
        :white -> 1
      end

    updated_execution =
      execution
      |> Map.put(:input, [color_at_new_position])

    do_paint_panels(new_panel_map, new_position, new_direction, updated_execution)
  end

  defp parse_output(:halt, panel_map, _, _) do
    panel_map |> Enum.count()
  end

  defp new_position({x, y}, :down), do: {x, y - 1}
  defp new_position({x, y}, :up), do: {x, y + 1}
  defp new_position({x, y}, :left), do: {x - 1, y}
  defp new_position({x, y}, :right), do: {x + 1, y}

  # I'm lazy and just typing out the possibilities :-)
  defp new_direction(:up, :left), do: :left
  defp new_direction(:left, :left), do: :down
  defp new_direction(:down, :left), do: :right
  defp new_direction(:right, :left), do: :up
  defp new_direction(:up, :right), do: :right
  defp new_direction(:right, :right), do: :down
  defp new_direction(:down, :right), do: :left
  defp new_direction(:left, :right), do: :up
end
