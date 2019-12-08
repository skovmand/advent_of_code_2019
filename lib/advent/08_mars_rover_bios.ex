defmodule Advent19.MarsRoverBios do
  @moduledoc """
  Rebooting a Mars Rover
  """

  @doc """
  Part 1: Verify the integrity of the transferred image
  """
  def verify_image_integrity(digit_list, x_size, y_size) do
    layer_with_fewest_zeroes =
      digit_list
      |> Enum.chunk_every(x_size * y_size)
      |> Enum.min_by(&count_element(&1, 0))

    count_element(layer_with_fewest_zeroes, 1) * count_element(layer_with_fewest_zeroes, 2)
  end

  defp count_element(list, element) do
    list |> Enum.count(&(&1 == element))
  end

  @doc """
  Part 2: Draw the image
  """
  def draw_image(digit_list, x_size, y_size) do
    decode_image(digit_list, x_size, y_size)
    |> Enum.map(fn row -> row |> Enum.map(&text_pixel/1) end)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end

  # Use O for white, blank space for black
  defp text_pixel(0), do: " "
  defp text_pixel(1), do: "O"

  @doc """
  Decode the image into the final representation
  """
  def decode_image(digit_list, x_size, y_size) do
    digit_list
    |> Enum.chunk_every(x_size * y_size)
    |> overlay_pixels(x_size, y_size)
    |> Enum.chunk_every(y_size)
  end

  # Overlay pixels to find the winning pixel for each layer
  defp overlay_pixels(layers, x_size, y_size) do
    0..(x_size * y_size - 1)
    |> Enum.reduce([], fn pixel, final_image ->
      color =
        layers
        |> Stream.map(&Enum.at(&1, pixel))
        |> Enum.find(&(&1 != 2))

      [color | final_image]
    end)
    |> Enum.reverse()
  end
end
