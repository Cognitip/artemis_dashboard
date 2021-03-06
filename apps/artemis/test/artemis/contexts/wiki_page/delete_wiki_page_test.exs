defmodule Artemis.DeleteWikiPageTest do
  use Artemis.DataCase

  import Artemis.Factories

  alias Artemis.WikiPage
  alias Artemis.DeleteWikiPage

  describe "call!" do
    test "raises an exception when id not found" do
      invalid_id = 50000000

      assert_raise Artemis.Context.Error, fn () ->
        DeleteWikiPage.call!(invalid_id, Mock.system_user())
      end
    end

    test "updates a record when passed valid params" do
      record = insert(:wiki_page)

      %WikiPage{} = DeleteWikiPage.call!(record, Mock.system_user())

      assert Repo.get(WikiPage, record.id) == nil
    end

    test "updates a record when passed an id and valid params" do
      record = insert(:wiki_page)

      %WikiPage{} = DeleteWikiPage.call!(record.id, Mock.system_user())

      assert Repo.get(WikiPage, record.id) == nil
    end
  end

  describe "call" do
    test "returns an error when record not found" do
      invalid_id = 50000000

      {:error, _} = DeleteWikiPage.call(invalid_id, Mock.system_user())
    end

    test "updates a record when passed valid params" do
      record = insert(:wiki_page)

      {:ok, _} = DeleteWikiPage.call(record, Mock.system_user())

      assert Repo.get(WikiPage, record.id) == nil
    end

    test "updates a record when passed an id and valid params" do
      record = insert(:wiki_page)

      {:ok, _} = DeleteWikiPage.call(record.id, Mock.system_user())

      assert Repo.get(WikiPage, record.id) == nil
    end
  end

  describe "broadcasts" do
    test "publishes event and record" do
      ArtemisPubSub.subscribe(Artemis.Event.get_broadcast_topic())

      {:ok, wiki_page} = DeleteWikiPage.call(insert(:wiki_page), Mock.system_user())

      assert_received %Phoenix.Socket.Broadcast{
        event: "wiki-page:deleted",
        payload: %{
          data: ^wiki_page
        }
      }
    end
  end
end
