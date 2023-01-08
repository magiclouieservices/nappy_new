defmodule NappyWeb.CustomPageLive.Studio do
  use NappyWeb, :live_view

  def render(assigns) do
    ~H"""
    <article class="container mx-auto py-24">
      <h1 class="text-center mx-auto w-[18ch] leading-tight font-tiempos-bold text-5xl">
        Branded and culturally diverse stock photos.
      </h1>
      <p class="text-center text-lg mt-4 mb-32">Introducing, Nappy Studio.</p>
      <img class="mx-auto max-w-3xl" src={Routes.static_path(@socket, "/images/studio_header.jpg")} />
      <p class="mt-28 max-w-md text-center mx-auto">
        We launched Nappy in 2017 on a mission to improve representation and to diversify stock photography.
      </p>
      <p class="mt-6 text-center">
        Since then, our photos have had...
      </p>
      <ul class="flex justify-between px-52 mt-28">
        <li
          :for={{metric, name} <- [{"220M", "Views"}, {"1M", "Downloads"}, {"35K", "Likes"}]}
          class="flex flex-col items-center gap-2"
        >
          <span class="font-tiempos-bold text-5xl"><%= metric %></span>
          <span><%= name %></span>
        </li>
      </ul>
      <p class="mt-28 max-w-md text-center mx-auto">
        And they've been used by some of the biggest brands in the world to diversify their:
      </p>
      <ul class="mt-28 max-w-md text-center mx-auto font-tiempos-bold text-4xl flex flex-col gap-4">
        <li :for={
          service <- [
            "Blog posts",
            "Websites",
            "Presentations",
            "Ebooks",
            "Social media",
            "Display ads",
            "Email Mktg"
          ]
        }>
          <%= service %>
        </li>
      </ul>
      <p class="mt-6 text-center">And more.</p>
      <img
        class="mx-auto mt-28 max-w-3xl"
        src={Routes.static_path(@socket, "/images/studio_green.png")}
      />
      <div class="mt-28 mx-auto max-w-lg">
        <p>And while this is a good thing...</p>
        <p class="mt-6 font-tiempos-bold text-4xl">
          We know “stock” photos don’t always work for your project needs.
        </p>
        <p class="mt-6">
          Sometimes the job calls for professional, high-quality, custom photography to properly capture your brand story.
        </p>
      </div>
      <img
        class="mx-auto mt-28 max-w-3xl"
        src={Routes.static_path(@socket, "/images/studio_instudio.jpg")}
      />
      <p class="mt-28 text-5xl mx-auto max-w-2xl font-tiempos-bold text-center">
        That's why we launched Nappy Studio
      </p>
      <p class="mt-8 max-w-xs text-center mx-auto">
        A photo studio that helps brands commission branded stock photography that features Black and Brown people.
      </p>
      <p class="mt-4 max-w-md text-center mx-auto">
        At a fraction of the cost to hire traditional studios.
      </p>
      <p class="mt-28 text-4xl font-tiempos-bold text-center">
        But don't just take our word for it...
      </p>
      <div class="grid grid-cols-2 justify-center gap-8 pt-28">
        <img class="max-w-xl justify-self-end" src={Routes.static_path(@socket, "/images/cnn.png")} />
        <div class="max-w-lg">
          <p class="font-tiempos-bold text-3xl">
            🌱 Improving diversity and representation in the outdoors, one photo at a time
          </p>
          <p class="mt-4">
            <em>
              "We're thrilled to partner with Nappy's Studio service to add more photos of people of color in the outdoors to their extensive portfolio. If a picture is worth a thousand words, we hope these photos will go a long way in creating a more inclusive outdoor story—and ultimately, a more inclusive children and nature movement."
            </em>
          </p>
          <div class="flex mt-2 mb-4">
            <img class="w-20" src={Routes.static_path(@socket, "/images/laura_mylan.png")} />
            <div class="flex flex-col justify-center ml-4">
              <span class="font-bold">Laura Mylan</span>
              <span>Children and Nature Network</span>
            </div>
          </div>
          <a
            href={Routes.collections_show_path(@socket, :show, "children-in-nature")}
            class="py-3 px-8 rounded-md shadow-sm font-light text-lg text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800"
          >
            View the collection
          </a>
        </div>
      </div>
      <div class="grid grid-cols-2 justify-center gap-8 pt-28">
        <div class="max-w-lg justify-self-end text-right">
          <p class="font-tiempos-bold text-3xl">
            👐🏾 Diversifying hands in stock photography
          </p>
          <p class="mt-8">
            <em>
              "We loved partnering with Nappy on our All Hands project! They understood our vision and executed with thought and care. 10/10 would collab again!"
            </em>
          </p>
          <div class="flex mt-6 mb-6 justify-end">
            <div class="flex flex-col justify-center mr-4">
              <span class="font-bold">Laura Mylan</span>
              <span>Metalab</span>
            </div>
            <img class="w-20" src={Routes.static_path(@socket, "/images/taylor_odgers.png")} />
          </div>
          <a
            href={Routes.collections_show_path(@socket, :show, "all-hands-collection")}
            class="py-3 px-8 rounded-md shadow-sm font-light text-lg text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800"
          >
            View the collection
          </a>
        </div>
        <img
          class="max-w-xl justify-self-start"
          src={Routes.static_path(@socket, "/images/metalab.png")}
        />
      </div>
      <p class="mt-28 max-w-md mx-auto text-4xl font-tiempos-bold text-center">
        Interested in learning more...
      </p>
      <div class="flex flex-col items-center mt-14">
        <a
          href="https://form.typeform.com/to/MWaKPL7n"
          target="_blank"
          rel="noopener noreferer nofollow"
          class="py-3 px-10 rounded-md shadow-sm font-light text-lg text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800"
        >
          Learn more
        </a>
        <a
          href={Routes.custom_page_contact_path(@socket, :contact)}
          class="text-sm hover:underline mt-2"
        >
          Or become a photographer
        </a>
      </div>
    </article>
    """
  end
end
