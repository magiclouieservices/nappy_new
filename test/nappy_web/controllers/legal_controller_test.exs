defmodule NappyWeb.LegalControllerTest do
  use NappyWeb.ConnCase

  import Nappy.AdminFixtures

  @create_attrs %{
    privacy_link: "some privacy_link",
    terms_of_agreement_link: "some terms_of_agreement_link"
  }
  @update_attrs %{
    privacy_link: "some updated privacy_link",
    terms_of_agreement_link: "some updated terms_of_agreement_link"
  }
  @invalid_attrs %{privacy_link: nil, terms_of_agreement_link: nil}

  describe "index" do
    test "lists all legal", %{conn: conn} do
      conn = get(conn, Routes.legal_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Legal"
    end
  end

  describe "new legal" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.legal_path(conn, :new))
      assert html_response(conn, 200) =~ "New Legal"
    end
  end

  describe "create legal" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.legal_path(conn, :create), legal: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.legal_path(conn, :show, id)

      conn = get(conn, Routes.legal_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Legal"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.legal_path(conn, :create), legal: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Legal"
    end
  end

  describe "edit legal" do
    setup [:create_legal]

    test "renders form for editing chosen legal", %{conn: conn, legal: legal} do
      conn = get(conn, Routes.legal_path(conn, :edit, legal))
      assert html_response(conn, 200) =~ "Edit Legal"
    end
  end

  describe "update legal" do
    setup [:create_legal]

    test "redirects when data is valid", %{conn: conn, legal: legal} do
      conn = put(conn, Routes.legal_path(conn, :update, legal), legal: @update_attrs)
      assert redirected_to(conn) == Routes.legal_path(conn, :show, legal)

      conn = get(conn, Routes.legal_path(conn, :show, legal))
      assert html_response(conn, 200) =~ "some updated privacy_link"
    end

    test "renders errors when data is invalid", %{conn: conn, legal: legal} do
      conn = put(conn, Routes.legal_path(conn, :update, legal), legal: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Legal"
    end
  end

  describe "delete legal" do
    setup [:create_legal]

    test "deletes chosen legal", %{conn: conn, legal: legal} do
      conn = delete(conn, Routes.legal_path(conn, :delete, legal))
      assert redirected_to(conn) == Routes.legal_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.legal_path(conn, :show, legal))
      end
    end
  end

  defp create_legal(_) do
    legal = legal_fixture()
    %{legal: legal}
  end
end
