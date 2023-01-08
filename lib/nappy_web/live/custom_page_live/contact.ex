defmodule NappyWeb.CustomPageLive.Contact do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center font-tiempos-bold text-5xl">
        Get in touch
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar socket={@socket} action={assigns.live_action} />
        <div class="col-span-6 justify-self-center leading-loose text-lg font-light">
          <p class="text-center font-bold">Questions? Comments?</p>
          <div>
            <p class="text-center">
              <i class="fa-solid fa-envelope"></i> hi@nappy.co
            </p>
            <img src={Routes.static_path(@socket, "/images/contact-form.png")} class="p-4" />
          </div>
        </div>
      </article>
    </div>
    """
  end
end
