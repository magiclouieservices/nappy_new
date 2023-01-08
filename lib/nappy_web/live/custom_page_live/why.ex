defmodule NappyWeb.CustomPageLive.Why do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center font-tiempos-bold text-5xl">
        Why we launched Nappy
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar socket={@socket} action={assigns.live_action} />
        <div class="col-span-6 leading-loose text-lg font-light">
          <p>
            What’s the first thing that comes to mind when you think of traditional stock photos? Let me guess… white backgrounds, New York City skyline, executives with their arms crossed, etc.
          </p>
          <p class="mt-4">
            Traditional stock photo websites have always been somewhat of a joke &mdash; especially in the photography community. Mostly because they are unrealistic representations of real people doing real things. Thankfully, over the last few years, we’ve seen a rise in free stock photography websites offering high quality and free photos filed under the creative commons license; websites like <a
              href="http://unsplash.com"
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline"
            >Unsplash</a>, <a
              href="http://pexels.com"
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline"
            >Pexels</a>, and <a
              href="http://shotstash.com"
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline"
            >Shot Stash</a>, to name a few.
          </p>
          <p class="mt-4">
            These sites are great! They’ve made it a lot easier for startups, small mom-and-pop shops, and big fortune 500 companies to have professional, candid photos that really represent today’s generation. What makes them so great is that they are curated from various photographers all around the world with their own unique styles and perspectives that they show in their work.
          </p>
          <p class="font-bold mt-4">Here’s the thing…</p>
          <p class="mt-4">
            I love Unsplash, Pexels, and Shot Stash, but one of the things I’ve noticed is that all of their content could use a little more diversity. As an
            <a
              href="http://shade.co"
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline"
            >
              influencer mgmt agency
            </a>
            for black and brown creators, we’re very intentional about cultural representation in the work that we do. And because of that, we aren’t always able to find the photos we need from those sites.
          </p>
          <p class="mt-4">
            <em>
              For example, if you were to type in the word ‘coffee’ on Unsplash, you’d rarely see a cup of coffee being held by black or brown hands. It’s the same result if you type in terms like ‘computer’ or ‘travel.’ You may find an image or two but they’re pretty rare. But black and brown people drink coffee too, we use computers, and we certainly love traveling.
            </em>
          </p>
          <p class="mt-4">
            And that’s why we launched <span class="font-bold">nappy</span>; to provide beautiful, high-res photos of black and brown people to startups, brands, agencies, and everyone else. Nappy makes it easy for companies to be purposeful about representation in their designs, presentations, and advertisements.
          </p>
          <p class="mt-4">
            Companies like Unsplash and Pexels have built great communities and platforms that make it easy for photographers from all walks of life to upload their photos and share them with the rest of the world. And with nappy, we plan on joining them to continue what they’ve started.
          </p>
          <p class="font-bold mt-4">And you can help too…</p>
          <p class="mt-4">
            Share this with everyone <em>(photographers and non-photographers)</em>
            you know and let’s tackle diversity and representation one photo at a time.
          </p>
          <p class="mt-4">
            If you’re a photographer, <em><a
                href={Routes.upload_path(@socket, :new)}
                class="underline"
              >submit your photos here</a></em>.
          </p>
        </div>
      </article>
    </div>
    """
  end
end
