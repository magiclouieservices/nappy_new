defmodule NappyWeb.CustomPageLive.New do
  use NappyWeb, :live_view

  def render(assigns) do
    ~H"""
    <article class="container mx-auto py-24 font-light leading-relaxed">
      <h1 class="text-center mx-auto w-[18ch] leading-tight font-tiempos-bold text-5xl">
        Nappy has a new look
      </h1>
      <p class="mt-24 max-w-md mx-auto text-center">
        We’re excited to share our new website with the Nappy community. What originally started as a side-project in 2017, has become one of the internet’s go-to sources for beautiful stock photos of Black and Brown people.
      </p>
      <p class="mt-6 max-w-md mx-auto text-center">
        With nearly 10,000 website visitors a day, we knew it was time for a new user experience. Introducing, Nappy v2.
      </p>
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        Responsive grid design
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/grid-design.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        Gorgeous photo previews
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/photo-preview.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        User profiles with stats
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/user-profile.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        Likes, followers, and more...
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/social-activities.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        Donations
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/donation.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        Private collections
      </p>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/collections.png")} />
      <p class="mt-28 text-2xl font-tiempos-bold text-center">
        New branded stock photo service
      </p>
      <a href={Routes.custom_page_studio_path(@socket, :studio)} class="flex justify-center underline">
        Learn more
      </a>
      <img class="mt-6 px-20" src={Routes.static_path(@socket, "/images/studio_header.jpg")} />
      <p class="mt-28 text-center font-tiempos-bold text-2xl">And more...</p>
      <p class="text-center mt-4 max-w-xl mx-auto">
        We're still making some final updates to the website. If anything looks out of place, click the "Feedback" button to let us know.
      </p>
      <p class="mt-16 text-center">
        <a href={Routes.home_index_path(@socket, :index)} class="underline">Explore the site</a>
        &vert;
        <a href={Routes.user_registration_path(@socket, :new)} class="underline">Register now</a>
      </p>
    </article>
    """
  end
end
