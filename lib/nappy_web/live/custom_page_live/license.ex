defmodule NappyWeb.CustomPageLive.License do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center font-tiempos-bold text-5xl">
        The Nappy License
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar socket={@socket} action={assigns.live_action} />
        <div class="col-span-6 leading-loose text-lg font-light">
          <p>
            All photos posted on Nappy are licensed under the
            <a
              href="https://creativecommons.org/publicdomain/zero/1.0"
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline font-bold"
            >
              Creative Commons Zero (CC0)
            </a>
            license so feel free to do your thing. That means you can download these photos, modify them, share them, distribute them, or use them for whatever you want <span class="font-bold">for free</span>. In fact, we encourage it. The more you use them, the more we’re helping improve the representation of black and brown people in media.
          </p>
          <ul class="mt-8">
            <li class="text-xl font-tiempos-bold">DO</li>
            <li :for={
              allowed <-
                [
                  ~s(Give photographer credits <em>(though not required\)</em>),
                  ~s(Use our photos for personal and commmercial projects),
                  ~s(Modify the photos to fit your needs)
                ]
            }>
              <i class="text-green-500 fa-regular fa-circle-check"></i>
              <span class="ml-2"><%= raw(allowed) %></span>
            </li>
          </ul>
          <ul class="mt-8">
            <li class="text-xl font-tiempos-bold">DONT</li>
            <li :for={
              not_allowed <-
                [
                  ~s(Repost our photos on other stock websites),
                  ~s(Resell our photos without significant modification),
                  ~s(Use these photos to degrade or insult its subjects)
                ]
            }>
              <i class="text-red-500 fa-regular fa-circle-xmark"></i>
              <span class="ml-2"><%= raw(not_allowed) %></span>
            </li>
          </ul>
          <p class="mt-4">
            If you have any questions,
            <.link navigate={Routes.custom_page_faq_path(@socket, :faq)} class="underline">
              check out our FAQs
            </.link>.
          </p>
        </div>
      </article>
    </div>
    """
  end
end
