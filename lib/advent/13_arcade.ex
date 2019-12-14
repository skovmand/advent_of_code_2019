defmodule Advent19.Arcade do
  @moduledoc """
  Running arcade games on the intcode runtime

  Start it from the terminal using: 
  mix run -e "Advent19.Arcade.play_game()"
  """

  alias Advent19.Common
  alias Advent19.Intcode.Runner
  alias Advent19.Intcode.Runtime.Execution

  @output_writer if(Mix.env() == :test, do: Advent19.OutputMock, else: Advent19.Output)

  @tiles %{
    0 => :empty,
    1 => :wall,
    2 => :block,
    3 => :horiz_paddle,
    4 => :ball
  }

  @doc """
  Play the game - useful function to start it outside a test
  """
  def play_game() do
    program =
      "input_13_arcade.txt"
      |> Path.expand("./input_files")
      |> File.read!()
      |> Common.integer_list()

    program |> run_game(free_play: true)
  end

  @doc """
  Run a game on the intcode runtime
  """
  def run_game(program, opts \\ []) do
    # An output handler that accumulates 3 values and then breaks with all three values
    # We'll use a map for this data structure
    output_handler = fn %Execution{output: output} = execution, output_value, continue_fn ->
      case output do
        %{x: -1, y: 0} ->
          {:new_score, output_value, execution |> Map.put(:output, %{})}

        %{x: _x, y: _y} = drawable ->
          drawable = drawable |> Map.put(:tile_id, Map.fetch!(@tiles, output_value))
          {:output, drawable, execution |> Map.put(:output, %{})}

        %{x: _x} ->
          execution
          |> Map.update!(:output, fn output -> output |> Map.put(:y, output_value) end)
          |> continue_fn.()

        %{} ->
          execution |> Map.put(:output, %{x: output_value}) |> continue_fn.()
      end
    end

    halt_handler =
      case opts |> Keyword.get(:mode, :play_game) do
        :count_blocks -> fn _ -> :halt_and_count_blocks end
        :play_game -> fn _ -> :halt_and_return_score end
      end

    execution = Runner.init(program, break_handlers: %{output: output_handler, halt: halt_handler}, output: %{})

    # If mode is :play_game, fix memory location 0
    execution =
      case Keyword.get(opts, :mode, :play_game) do
        :count_blocks -> execution
        :play_game -> execution |> Map.update!(:memory, fn memory -> memory |> Map.put(0, 2) end)
      end

    clear_screen()

    initial_game_state = %{
      score: 0,
      next_move: 0,
      game_started?: false,
      ball_position: nil,
      paddle_position: nil,
      block_count: 0
    }

    execution |> do_run_game(initial_game_state)
  end

  # Start function for the game loop
  defp do_run_game(execution, game_state) do
    # Uncomment this for a slower execution
    # if game_state.game_started?, do: :timer.sleep(5)

    execution |> Map.put(:input, [game_state.next_move]) |> Runner.run() |> handle_response(game_state)
  end

  # Erase blocks - don't get input for that
  defp handle_response({:output, %{tile_id: :empty} = drawable, execution}, game_state) do
    draw_tile(drawable)
    do_run_game(execution, game_state)
  end

  defp handle_response({:output, drawable, execution}, game_state) do
    game_state =
      game_state
      |> update_game_started?(drawable)
      |> update_block_count(drawable)
      |> update_paddle_position(drawable)
      |> update_ball_position(drawable)
      |> autoinput()

    draw_tile(drawable)
    do_run_game(execution, game_state)
  end

  defp handle_response({:new_score, score, execution}, game_state) do
    draw_score(score)

    do_run_game(execution, game_state |> Map.put(:score, score))
  end

  # Halt handler for part 1: Halt and return the number of :block tiles
  defp handle_response(:halt_and_count_blocks, %{block_count: block_count}), do: block_count

  # Halt handler for part 2: Halt and return score
  defp handle_response(:halt_and_return_score, %{score: score}), do: score

  # 
  # Internal helpers ----------->
  #

  # Update ball/paddle position in game state
  defp update_ball_position(game_state, %{x: x, y: y, tile_id: :ball}) do
    game_state |> Map.put(:ball_position, {x, y})
  end

  defp update_ball_position(game_state, _), do: game_state

  defp update_paddle_position(game_state, %{x: x, y: y, tile_id: :horiz_paddle}) do
    game_state |> Map.put(:paddle_position, {x, y})
  end

  defp update_paddle_position(game_state, _), do: game_state

  defp update_block_count(game_state, %{tile_id: :block}),
    do: game_state |> Map.update!(:block_count, fn count -> count + 1 end)

  defp update_block_count(game_state, _), do: game_state

  # Autoplay
  defp autoinput(%{paddle_position: {px, _}, ball_position: {bx, _}} = game_state) when px > bx,
    do: game_state |> Map.put(:next_move, -1)

  defp autoinput(%{paddle_position: {px, _}, ball_position: {bx, _}} = game_state) when px < bx,
    do: game_state |> Map.put(:next_move, 1)

  defp autoinput(game_state), do: game_state |> Map.put(:next_move, 0)

  defp update_game_started?(game_state, %{x: 39, y: 23}), do: game_state |> Map.put(:game_started?, true)
  defp update_game_started?(game_state, _), do: game_state

  @graphics_map %{
    empty: " ",
    wall: "|",
    block: "B",
    horiz_paddle: "-",
    ball: "O"
  }

  defp draw_tile(drawable) do
    tile = Map.get(@graphics_map, drawable.tile_id)
    @output_writer.write([IO.ANSI.cursor(drawable.y + 3, drawable.x + 1), IO.ANSI.light_blue(), tile, IO.ANSI.reset()])
    @output_writer.write([IO.ANSI.cursor(30, 0)])
  end

  defp draw_score(score) do
    @output_writer.write([IO.ANSI.cursor(0, 0), "Score: #{score}"])
    @output_writer.write([IO.ANSI.cursor(30, 0)])
  end

  defp clear_screen() do
    @output_writer.write([IO.ANSI.clear()])
  end
end
