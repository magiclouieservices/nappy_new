defmodule NappyWeb.Components.CustomPageComponent do
  use NappyWeb, :component

  @moduledoc false

  @doc """
  Sidebar component for custom page.

  ## Examples

    <sidebar />
  """
  def sidebar(assigns) do
    ~H"""
    <ul class="col-span-2 flex flex-col gap-3">
      <li :for={
        {title, path, action} <-
          [
            {"Our Mission", :custom_page_why_path, :why},
            {"License", :custom_page_license_path, :license},
            {"Terms", :custom_page_terms_path, :terms},
            {"FAQ", :custom_page_faq_path, :faq},
            {"Contact", :custom_page_contact_path, :contact}
          ]
      }>
        <.link
          navigate={apply(Routes, path, [@socket, action])}
          class={"#{if @action === action, do: ~s(font-bold), else: ~s(underline text-gray-500)}"}
        >
          <%= title %>
        </.link>
      </li>
    </ul>
    """
  end
end
