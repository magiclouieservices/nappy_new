defmodule NappyWeb.Components.RelatedTagsComponentTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

  alias NappyWeb.Components.RelatedTagsComponent
  import Phoenix.Component
  import Phoenix.LiveViewTest

  describe "RelatedTagsComponent" do
    test "success: check if related_tags is displayed" do
      assigns = %{
        id: "related-tags",
        related_tags: ["test", "testpic"]
      }

      title = ~s(<p class="mt-8 mb-4 font-tiempos-bold text-center text-2xl">Related Tags</p>)
      first_elem = ~s(<li>test</li>)
      second_elem = ~s(<li>testpic</li>)

      assert render_component(RelatedTagsComponent, assigns) =~ title
      assert render_component(RelatedTagsComponent, assigns) =~ first_elem
      assert render_component(RelatedTagsComponent, assigns) =~ second_elem
    end

    test "error: empty related_tags" do
      assigns = %{
        id: "related-tags",
        related_tags: []
      }

      empty_list =
        ~s(<ul class="mx-auto w-96 flex flex-wrap justify-center gap-2">\n    \n  </ul>)

      assert render_component(RelatedTagsComponent, assigns) =~ empty_list
    end
  end
end
