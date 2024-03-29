defmodule NappyWeb.Components.HomeHeaderComponent do
  use NappyWeb, :live_component

  alias NappyWeb.Components.HeaderSearchComponent
  alias NappyWeb.Components.TrendingKeywordsComponent

  @moduledoc false

  @doc """
  Live component of a gallery.

  ## Examples

    <.live_component
      module={HomeHeaderComponent}
      id="home-header"
    />
  """
  def render(assigns) do
    ~H"""
    <div class="relative">
      <img
        loading="lazy"
        class="w-screen md:h-96 sm:h-64 xs:h-60 object-cover"
        src={Routes.static_path(@socket, "/images/header_search.jpg")}
      />
      <div class="absolute inset-0 z-1 flex flex-col gap-4 justify-center items-center text-white bg-[rgba(0,0,0,.5)]">
        <span class="lg:max-w-lg md:max-w-md sm:max-w-sm xs:max-w-xs lg:text-4xl md:text-3xl sm:text-2xl xs:text-xl font-tiempos-bold text-center">
          Beautiful photos of Black and Brown people, for free.
        </span>
        <.live_component module={HeaderSearchComponent} id="header-search" class="mt-1 text-black" />
        <.live_component module={TrendingKeywordsComponent} id="trending-keywords" />
      </div>
    </div>
    """
  end
end
