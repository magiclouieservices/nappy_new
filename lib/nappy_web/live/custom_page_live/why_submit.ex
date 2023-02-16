defmodule NappyWeb.CustomPageLive.WhySubmit do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center font-tiempos-bold text-5xl">
        What's in it for me?
      </h1>
      <p class="text-center mt-4 text-lg font-light">
        5 reasons to submit your photos to Nappy
      </p>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar
          side_links="single_upload"
          socket={@socket}
          action={assigns.live_action}
        />
        <div class="col-span-6 leading-loose text-lg font-light">
          <ol class="flex flex-col gap-16 list-decimal font-tiempos-bold text-2xl">
            <li>
              <span>
                Improve representation
              </span>
              <span class="block mt-4 font-sans font-light text-lg">
                We’re starting with the most important reason of all. By uploading your photos on Nappy, you help contribute to a digital world that’s more representative of the diverse world that we live in today. Improving representation also breaks down stereotypes which, in turn, will reduce racial profiling and race based discrimination.
              </span>
            </li>
            <li>
              <span>
                Marketing and exposure
              </span>
              <span class="block mt-4 font-sans font-light text-lg">
                Yeah yeah yeah, everyone says that, but it’s true. For starters, our website gets nearly 10k visitors a day and often times visitors reach out to Nappy photographers to commission other photography work. Secondly, our photos are used by large corporations like CNN, Yahoo, Forbes, etc. Although it’s not required, they often source the photographer in their work which can serve as social proof for your website and portfolio.
              </span>
            </li>
            <li>
              <span>
                Nappy portfolio
              </span>
              <span class="block mt-4 font-sans font-light text-lg">
                Every photographer gets a beautiful profile to showcase their photos. The profile includes bio, images, and stats <em>(views, likes, downloads, etc)</em>. You can send your Nappy profile to potential clients to show them your work.
              </span>
            </li>
            <li>
              <span>
                Make money
              </span>
              <span class="block mt-4 font-sans font-light text-lg">
                In addition to marketing benefits of uploading to Nappy, there are also two ways you can make money while contributing to a better world. First, every profile comes with a
                <strong class="font-bold">donate</strong>
                button. This means that website visitors will be able to donate to you for making your photos available to world. Secondly, there are a few times that brands reach out to us to commission custom photos from us. We pass those jobs to our Nappy photographers. Finally, we host photo challenges where winners of these challenges win money and prizes.
              </span>
            </li>
            <li>
              <span>
                Why not?
              </span>
              <span class="block mt-4 font-sans font-light text-lg">
                And finally, why not? On typical photoshoots, only 20% of the photos are actually used. What happens to the 80%? They need a home. We can be their home :).
              </span>
            </li>
          </ol>
          <div class="mt-8 flex flex-col items-center">
            <p>Ready to get started?</p>
            <.link
              navigate={Routes.upload_new_path(@socket, :new)}
              class="inline mt-2 py-3 px-10 rounded-md shadow-sm font-light text-lg text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800"
            >
              Submit Photos
            </.link>
            <.link
              navigate={Routes.custom_page_guidelines_path(@socket, :guidelines)}
              class="text-sm underline mt-4"
            >
              Or read the guidelines
            </.link>
          </div>
        </div>
      </article>
    </div>
    """
  end
end
