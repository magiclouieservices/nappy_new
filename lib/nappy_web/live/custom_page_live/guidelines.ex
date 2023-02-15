defmodule NappyWeb.CustomPageLive.Guidelines do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="block mx-auto text-center font-tiempos-bold text-5xl max-w-[23ch]">
        Nappy's submission guidelines
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar
          side_links="single_upload"
          socket={@socket}
          action={assigns.live_action}
        />
        <div class="col-span-6 leading-loose text-lg font-light">
          <p>
            Thank you for your interest in contributing photos to Nappy. To increase your chances of getting featured, here are some important things to keep in mind:
          </p>
          <ul class="mt-4 flex flex-col gap-4">
            <li class="font-tiempos-bold">
              Don’t submit photos you don’t have the rights to
            </li>
            <li class="font-tiempos-bold">
              Don’t submit photos of people without their permission
            </li>
            <li class="font-tiempos-bold">
              Don’t submit photos you don’t want used commercially
            </li>
            <li class="font-tiempos-bold">
              Don’t submit low-quality images under 2000 x 1300 pixels
            </li>
            <li class="font-tiempos-bold">
              Don’t submit selfies (or cell phone photos)
            </li>
            <li class="font-tiempos-bold">
              Don’t submit blurry or unclear images
            </li>
            <li class="font-tiempos-bold">
              Don’t submit photos that doesn’t include Black or Brown subjects
            </li>
            <li class="font-tiempos-bold">
              Don’t submit too many identical photos (try different angles)
            </li>
            <li class="font-tiempos-bold">
              Don’t submit over edited photos
            </li>
            <li class="font-tiempos-bold">
              Don’t submit photos that are too dark (unless that’s the style)
            </li>
            <li class="font-tiempos-bold">
              Don’t submit photos with text/graphics/logos on them
            </li>
            <li class="font-tiempos-bold">
              Don’t submit adult content / NSFW photos
            </li>
          </ul>
          <div class="mt-8 flex flex-col items-center">
            <p>Ready to help us improve representation?</p>
            <.link
              navigate={Routes.upload_new_path(@socket, :new)}
              class="inline mt-2 py-3 px-10 rounded-md shadow-sm font-light text-lg text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800"
            >
              Submit Photos
            </.link>
            <.link
              navigate={Routes.custom_page_why_submit_path(@socket, :why_submit)}
              class="text-sm underline mt-4"
            >
              Why should I submit?
            </.link>
          </div>
        </div>
      </article>
    </div>
    """
  end
end
