defmodule ShortenUrl.LogsTest do
  use ShortenUrl.DataCase

  alias ShortenUrl.Logs

  describe "activities" do
    alias ShortenUrl.Logs.Activity

    import ShortenUrl.LogsFixtures

    @invalid_attrs %{action: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Logs.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Logs.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{action: "some action"}

      assert {:ok, %Activity{} = activity} = Logs.create_activity(valid_attrs)
      assert activity.action == "some action"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_activity(@invalid_attrs)
    end

    # test "update_activity/2 with valid data updates the activity" do
    #   activity = activity_fixture()
    #   update_attrs = %{action: "some updated action"}

    #   assert {:ok, %Activity{} = activity} = Logs.update_activity(activity, update_attrs)
    #   assert activity.action == "some updated action"
    # end

    # test "update_activity/2 with invalid data returns error changeset" do
    #   activity = activity_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Logs.update_activity(activity, @invalid_attrs)
    #   assert activity == Logs.get_activity!(activity.id)
    # end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Logs.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Logs.change_activity(activity)
    end
  end
end
