defmodule Nappy.SlugTest do
  use ExUnit.Case, async: true

  alias Nappy.Admin.Slug

  describe "Slug" do
    test "generate slug without ampersand" do
      input = "[\"Pattern\", \"Matching\", \"In\", \"Elixir\"] = [a, b, c, d]"

      assert "pattern-matching-in-elixir-a-b-c-d" === Slug.slugify(input)
    end

    test "generate slug with ampersand" do
      input = "My slug generator & simple test "

      assert "my-slug-generator-and-simple-test" === Slug.slugify(input)
    end
  end
end
