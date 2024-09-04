defmodule ShortenUrl.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShortenUrl.Logs` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        action: "some action"
      })
      |> ShortenUrl.Logs.create_activity()

    activity
  end
end
