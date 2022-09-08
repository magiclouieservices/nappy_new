defmodule Nappy.BuilderTest do
  use Nappy.DataCase

  alias Nappy.Builder

  describe "pages" do
    alias Nappy.Builder.Page

    import Nappy.BuilderFixtures

    @invalid_attrs %{content: nil, is_enabled: nil, slug: nil, thumbnail: nil, title: nil}

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Builder.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Builder.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{
        content: "some content",
        is_enabled: "some is_enabled",
        slug: "some slug",
        thumbnail: "some thumbnail",
        title: "some title"
      }

      assert {:ok, %Page{} = page} = Builder.create_page(valid_attrs)
      assert page.content == "some content"
      assert page.is_enabled == "some is_enabled"
      assert page.slug == "some slug"
      assert page.thumbnail == "some thumbnail"
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Builder.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()

      update_attrs = %{
        content: "some updated content",
        is_enabled: "some updated is_enabled",
        slug: "some updated slug",
        thumbnail: "some updated thumbnail",
        title: "some updated title"
      }

      assert {:ok, %Page{} = page} = Builder.update_page(page, update_attrs)
      assert page.content == "some updated content"
      assert page.is_enabled == "some updated is_enabled"
      assert page.slug == "some updated slug"
      assert page.thumbnail == "some updated thumbnail"
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Builder.update_page(page, @invalid_attrs)
      assert page == Builder.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Builder.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Builder.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Builder.change_page(page)
    end
  end
end
