defmodule Atlas.UpdateUserTest do
  use Atlas.DataCase

  import Atlas.Factories

  alias Atlas.UpdateUser

  describe "call!" do
    test "raises an exception when id not found" do
      invalid_id = 50000000
      params = params_for(:user)

      assert_raise Atlas.Context.Error, fn () ->
        UpdateUser.call!(invalid_id, params, Mock.root_user())
      end
    end

    test "returns successfully when params are empty" do
      user = insert(:user)
      params = %{}

      updated = UpdateUser.call!(user, params, Mock.root_user())

      assert updated.name == user.name
    end

    test "updates a record when passed valid params" do
      user = insert(:user)
      params = params_for(:user)

      updated = UpdateUser.call!(user, params, Mock.root_user())

      assert updated.name == params.name
    end

    test "updates a record when passed an id and valid params" do
      user = insert(:user)
      params = params_for(:user)

      updated = UpdateUser.call!(user.id, params, Mock.root_user())

      assert updated.name == params.name
    end
  end

  describe "call" do
    test "returns an error when id not found" do
      invalid_id = 50000000
      params = params_for(:user)

      {:error, _} = UpdateUser.call(invalid_id, params, Mock.root_user())
    end

    test "returns successfully when params are empty" do
      user = insert(:user)
      params = %{}

      {:ok, updated} = UpdateUser.call(user, params, Mock.root_user())

      assert updated.name == user.name
    end

    test "updates a record when passed valid params" do
      user = insert(:user)
      params = params_for(:user)

      {:ok, updated} = UpdateUser.call(user, params, Mock.root_user())

      assert updated.name == params.name
    end

    test "updates a record when passed an id and valid params" do
      user = insert(:user)
      params = params_for(:user)

      {:ok, updated} = UpdateUser.call(user.id, params, Mock.root_user())

      assert updated.name == params.name
    end
  end

  describe "call - associations" do
    test "adds associations and updates record" do
      role = insert(:role)
      user = insert(:user)

      user = Repo.preload(user, [:user_roles])

      assert user.user_roles == []

      # Add Association

      params = %{
        id: user.id,
        email: user.email,
        name: "Updated Name",
        user_roles: [
          %{role_id: role.id}
        ]
      }

      {:ok, updated} = UpdateUser.call(user.id, params, Mock.root_user())

      assert updated.user_roles != []
      assert updated.name == "Updated Name"
    end

    test "removes associations when explicitly passed an empty value" do
      user = :user
        |> insert
        |> with_user_roles

      user = Repo.preload(user, [:user_roles])

      assert length(user.user_roles) == 3

      # Keeps existing associations if the association key is not passed

      params = %{
        id: user.id,
        name: "New Name"
      }

      {:ok, updated} = UpdateUser.call(user.id, params, Mock.root_user())

      assert length(updated.user_roles) == 3

      # Only removes associations when the association key is explicitly passed

      params = %{
        id: user.id,
        user_roles: []
      }

      {:ok, updated} = UpdateUser.call(user.id, params, Mock.root_user())

      assert length(updated.user_roles) == 0
    end
  end

  describe "broadcast" do
    test "publishes event and record" do
      AtlasPubSub.subscribe(Atlas.Event.get_broadcast_topic())

      user = insert(:user)
      params = params_for(:user)

      {:ok, updated} = UpdateUser.call(user, params, Mock.root_user())

      assert_received %Phoenix.Socket.Broadcast{
        event: "user:updated",
        payload: %{
          data: ^updated
        }
      }
    end
  end
end