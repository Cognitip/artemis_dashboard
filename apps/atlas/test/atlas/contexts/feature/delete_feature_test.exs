defmodule Atlas.DeleteFeatureTest do
  use Atlas.DataCase

  import Atlas.Factories

  alias Atlas.Feature
  alias Atlas.DeleteFeature

  describe "call!" do
    test "raises an exception when id not found" do
      invalid_id = 50000000

      assert_raise Atlas.Context.Error, fn () ->
        DeleteFeature.call!(invalid_id, Mock.system_user())
      end
    end

    test "updates a record when passed valid params" do
      record = insert(:feature)

      %Feature{} = DeleteFeature.call!(record, Mock.system_user())

      assert Repo.get(Feature, record.id) == nil
    end

    test "updates a record when passed an id and valid params" do
      record = insert(:feature)

      %Feature{} = DeleteFeature.call!(record.id, Mock.system_user())

      assert Repo.get(Feature, record.id) == nil
    end
  end

  describe "call" do
    test "returns an error when record not found" do
      invalid_id = 50000000

      {:error, _} = DeleteFeature.call(invalid_id, Mock.system_user())
    end

    test "updates a record when passed valid params" do
      record = insert(:feature)

      {:ok, _} = DeleteFeature.call(record, Mock.system_user())

      assert Repo.get(Feature, record.id) == nil
    end

    test "updates a record when passed an id and valid params" do
      record = insert(:feature)

      {:ok, _} = DeleteFeature.call(record.id, Mock.system_user())

      assert Repo.get(Feature, record.id) == nil
    end
  end

  describe "broadcasts" do
    test "publishes event and record" do
      AtlasPubSub.subscribe(Atlas.Event.get_broadcast_topic())

      {:ok, feature} = DeleteFeature.call(insert(:feature), Mock.system_user())

      assert_received %Phoenix.Socket.Broadcast{
        event: "feature:deleted",
        payload: %{
          data: ^feature
        }
      }
    end
  end
end
