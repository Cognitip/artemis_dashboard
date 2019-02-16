defmodule Atlas.CreateFeatureTest do
  use Atlas.DataCase

  import Atlas.Factories

  alias Atlas.CreateFeature

  describe "call!" do
    test "returns error when params are empty" do
      assert_raise Atlas.Context.Error, fn () ->
        CreateFeature.call!(%{}, Mock.root_user())
      end
    end

    test "creates a feature when passed valid params" do
      params = params_for(:feature)

      feature = CreateFeature.call!(params, Mock.root_user())

      assert feature.name == params.name
    end
  end

  describe "call" do
    test "returns error when params are empty" do
      {:error, changeset} = CreateFeature.call(%{}, Mock.root_user())

      assert errors_on(changeset).slug == ["can't be blank"]
    end

    test "creates a feature when passed valid params" do
      params = params_for(:feature)

      {:ok, feature} = CreateFeature.call(params, Mock.root_user())

      assert feature.name == params.name
    end
  end

  describe "broadcasts" do
    test "publishes event and record" do
      AtlasPubSub.subscribe(Atlas.Event.get_broadcast_topic())

      {:ok, feature} = CreateFeature.call(params_for(:feature), Mock.root_user())

      assert_received %Phoenix.Socket.Broadcast{
        event: "feature:created",
        payload: %{
          data: ^feature
        }
      }
    end
  end
end