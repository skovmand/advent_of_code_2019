defmodule Advent19.MarsRoverBios do
  @moduledoc """
  Rebooting a Mars Rover
  """

  @doc """
  Part 1: Verify the integrity of the transferred image
  """
  def verify_image_integrity(digit_list) do
    layer_with_fewest_zeroes =
      digit_list
      |> Enum.chunk_every(6 * 25)
      |> Enum.min_by(&count_element(&1, 0))

    count_element(layer_with_fewest_zeroes, 1) * count_element(layer_with_fewest_zeroes, 2)
  end

  defp count_element(list, element) do
    list |> Enum.count(&(&1 == element))
  end
end
