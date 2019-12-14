defmodule Advent19.OutputMock do
  @moduledoc """
  A module that simply writes output to the terminal.
  Used like this to allow mocking during testing
  """

  def write(_output), do: :ok
end

