defmodule NappyWeb.Router do
  use NappyWeb, :router
  use Honeybadger.Plug

  import NappyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NappyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NappyWeb do
    pipe_through :browser

    get "/download/:resolution", DownloadController, :download

    live "/popular-searches", PopularSearchesLive.Show, :show

    live "/why", CustomPageLive.Why, :why
    live "/why-submit", CustomPageLive.WhySubmit, :why_submit
    live "/guidelines", CustomPageLive.Guidelines, :guidelines
    live "/license", CustomPageLive.License, :license
    live "/terms", CustomPageLive.Terms, :terms
    live "/faq", CustomPageLive.FAQ, :faq
    live "/contact", CustomPageLive.Contact, :contact
    live "/new", CustomPageLive.New, :new
    live "/studio", CustomPageLive.Studio, :studio

    live "/collections", CollectionsLive.Index, :index
    live "/categories", CategoryLive.Index, :index

    # for gallery_component checking @current_user assigns
    live_session :check_auth, on_mount: [{NappyWeb.LiveAuth, :check_auth}] do
      live "/", HomeLive.Index, :index

      live "/photo/:slug", ImageLive.Show, :show

      live "/collection/:slug", CollectionsLive.Show, :show

      live "/category/:slug", CategoryLive.Show, :show

      live "/user/:username", UserProfileLive.Show, :show

      live "/search", SearchLive.Show, :show
      live "/search/:query", SearchLive.Show, :show
    end

    # resources "/legal", LegalController
    # resources "/seo", SeoController
    # resources "/subscribers", SubscriberController

    # paths =
    #   with {:ok, file} <- File.read(Nappy.slug_paths_filename()) do
    #     String.split(file, "\n", trim: true)
    #   else
    #     {:error, _posix} ->
    #       Nappy.Builder.write_slug_paths_to_file()

    #       Nappy.slug_paths_filename()
    #       |> File.read!()
    #       |> String.split("\n", trim: true)
    #   end

    # paths =
    #   "priv/repo/slug_paths.txt"
    #   |> File.read!()
    #   |> String.split("\n", trim: true)

    # for path <- paths do
    #   get "/#{path}", CustomPageController, :index
    # end
  end

  # Other scopes may use custom stacks.
  # scope "/api", NappyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NappyWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NappyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/signup", UserRegistrationController, :new
    post "/signup", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/reset-password", UserResetPasswordController, :new
    post "/reset-password", UserResetPasswordController, :create
    get "/reset-password/:token", UserResetPasswordController, :edit
    put "/reset-password/:token", UserResetPasswordController, :update
  end

  scope "/", NappyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/upload", UploadLive.New, :new

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/admin", NappyWeb do
    pipe_through [:browser, :require_authenticated_user, :admin_only]

    live "/dashboard", AdminLive.Dashboard, :dashboard
    live "/images", AdminLive.Images, :images
    live "/settings", AdminLive.Settings, :settings
    live "/bulk-upload", AdminLive.BulkUpload, :bulk_upload
    live "/categories", AdminLive.Categories, :categories
    live "/collections", AdminLive.Collections, :collections
    live "/pages", AdminLive.Pages, :pages
  end

  scope "/", NappyWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update

    get "/:fallback", HomeController, :fallback
  end
end
