defmodule Advent19.Vectors do
  @moduledoc """
  Tools for vector calculations
  """

  @doc """
  Create a vector from two coordinates
  """
  def from(p1, p2) do
    p1_list = p1 |> Tuple.to_list()
    p2_list = p2 |> Tuple.to_list()

    Enum.zip(p1_list, p2_list)
    |> Enum.map(fn {p1, p2} -> p2 - p1 end)
    |> List.to_tuple()
  end

  @doc """
  Calculate the dot product of two vectors
  """
  def dot_product(v1, v2) do
    v1_list = v1 |> Tuple.to_list()
    v2_list = v2 |> Tuple.to_list()

    Enum.zip(v1_list, v2_list)
    |> Enum.reduce(0, fn {s1, s2}, acc -> acc + s1 * s2 end)
  end

  @doc """
  Calculate the length of a vector
  """
  def vector_length(v1) do
    v1
    |> Tuple.to_list()
    |> Enum.reduce(0, fn s1, acc -> acc + s1 * s1 end)
    |> :math.sqrt()
  end

  @doc """
  Calculate the angle between two vectors in radians, travelling along the whole unit circle,
  so that 0 < angle < 2pi
  """
  def vector_angle(v1, {_, v2_y} = v2) when v2_y >= 0 do
    cos_theta = dot_product(v1, v2) / (vector_length(v1) * vector_length(v2))

    :math.acos(cos_theta)
  end

  def vector_angle(v1, v2) do
    cos_theta = dot_product(v1, v2) / (vector_length(v1) * vector_length(v2))

    2 * :math.pi() - :math.acos(cos_theta)
  end
end
