defmodule AtlasWeb.FeaturePageTest do
  use AtlasWeb.ConnCase
  use ExUnit.Case
  use Hound.Helpers

  import Atlas.Factories
  import AtlasWeb.BrowserHelpers
  import AtlasWeb.Router.Helpers

  @moduletag :browser_test
  @url feature_url(AtlasWeb.Endpoint, :index)

  hound_session()

  describe "authentication" do
    test "requires authentication" do
      navigate_to(@url)

      assert redirected_to_sign_in_page?()
    end
  end

  describe "index" do
    setup do
      browser_sign_in()
      navigate_to(@url)

      {:ok, []}
    end

    test "page content" do
      assert page_title() == "Atlas"
      assert visible?("Listing Features")
    end
  end

  describe "new / create" do
    setup do
      browser_sign_in()
      navigate_to(@url)

      {:ok, []}
    end

    test "submitting an empty form shows an error" do
      click_link("New")
      submit_form()

      assert visible?("can't be blank")
    end

    test "successfully creates a new record" do
      click_link("New")

      fill_inputs(%{
        feature_name: "Test Name",
        feature_slug: "test-slug"
      })

      submit_form()

      assert visible?("Test Name")
      assert visible?("test-slug")
    end
  end

  describe "show" do
    setup do
      feature = insert(:feature)

      browser_sign_in()
      navigate_to(@url)

      {:ok, feature: feature}
    end

    test "page content", %{feature: feature} do
      click_link(feature.slug)

      assert visible?(feature.name)
      assert visible?(feature.slug)
    end
  end

  describe "edit / update" do
    setup do
      feature = insert(:feature)

      browser_sign_in()
      navigate_to(@url)

      {:ok, feature: feature}
    end

    test "successfully updates record", %{feature: feature} do
      click_link(feature.slug)
      click_link("Edit")

      fill_inputs(%{
        feature_name: "Updated Name",
        feature_slug: "updated-slug"
      })

      submit_form()

      assert visible?("Updated Name")
      assert visible?("updated-slug")
    end
  end

  describe "delete" do
    setup do
      feature = insert(:feature)

      browser_sign_in()
      navigate_to(@url)

      {:ok, feature: feature}
    end

    @tag :uses_browser_alert_box
    test "deletes record and redirects to index", %{feature: feature} do
      click_link(feature.slug)
      click_button("Delete")
      accept_dialog()

      assert current_url() == @url
      assert not visible?(feature.slug)
    end
  end
end
