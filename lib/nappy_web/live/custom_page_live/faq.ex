defmodule NappyWeb.CustomPageLive.FAQ do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center mx-auto w-[18ch] font-tiempos-bold text-5xl">
        Frequently Asked Questions
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar side_links="about" socket={@socket} action={assigns.live_action} />
        <div class="col-span-6 leading-loose text-lg font-light">
          <p class="font-bold mt-4">How can I use the photos I download from this website?</p>
          <p>
            Our photos are available for both personal and commercial use. Feel free to use them for your blog posts, websites, presentations, ebooks, social media, display ads, and more. To learn more about our usage, check out our
            <.link
              navigate={Routes.custom_page_license_path(@socket, :license)}
              target="_blank"
              rel="noopener noreferer nofollow"
              class="underline"
            >
              license
            </.link>.
          </p>
          <p class="font-bold mt-6">Can I still use photos that are no longer on your site?</p>
          <p>
            Our contributors have the ability to remove their photos from Nappy at anytime. Though our license cannot prevent you from using their images once it's been removed, we hope that you'd respect the photographers and model(s) wishes.
          </p>
          <p class="font-bold mt-6">
            Do I have to give credit to the photographer(s) when using their photo(s)?
          </p>
          <p>
            The cc0 license gives you permission to use our photos without crediting the photographers. Well, you probably should still give credit because... well... it's the nice thing to do ?.
          </p>
          <p class="font-bold mt-6">
            How do I remove one of my photos (or a photo of me) from Nappy?
          </p>
          <p>
            Sorry to see you go. If you're a photographer,
            <a href={Routes.user_session_path(@socket, :new)} class="underline">login</a>
            to your profile, open the photo you'd like to delete, then click the delete button at the bottom of the page. If you're a model that wants to remove your photos from our library,
            <.link navigate={Routes.custom_page_contact_path(@socket, :contact)} class="underline">
              click here
            </.link>
            to get in touch with our team.
          </p>
          <p class="font-bold mt-6">How do I support Nappy?</p>
          <p>
            Thank you for your interest in our work. We're humbled. If you'd like to support our work, be sure to donate to our photographers (found on their profiles) and continue to share Nappy to your network.
          </p>
          <p class="mt-4">
            Feel free to
            <.link navigate={Routes.custom_page_contact_path(@socket, :contact)} class="underline">
              contact
            </.link>
            us or shoot us an email to <span class="font-bold">hi@nappy.co</span>.
          </p>
        </div>
      </article>
    </div>
    """
  end
end
