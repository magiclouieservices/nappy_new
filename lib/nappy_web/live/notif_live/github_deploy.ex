defmodule NappyWeb.NotifLive.GithubDeploy do
  use NappyWeb, :live_view
  alias Phoenix.PubSub

  @deployment_steps %{
    "deploy" => %{next_step: "create-org", text: "Creating org"},
    "create-org" => %{next_step: "create-repo", text: "Creating repo"},
    "create-repo" => %{next_step: "push-contents", text: "Pushing contents"},
    "push-contents" => %{next_step: "done", text: "Done!"}
  }
  @topic "deployments"

  def render(assigns) do
    ~H"""
    <div class="container mx-auto">
      <div class="bar">
        <button
          phx-click="deploy"
          type="button"
          class="rounded bg-indigo-600 px-2 py-1 text-xs font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Deploy to Github
        </button>
        <div class="github-deploy">
          Status: <span class={@status}><%= @text %></span>
        </div>
      </div>
      <button class="border" phx-click="increment" phx-value-inc={@inc}>increment</button>
      <button class="border" phx-click="decrement" phx-value-inc={@inc}>decrement</button>
      <%= @inc %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(Nappy.PubSub, @topic)

    socket =
      socket
      |> assign(text: "Ready!", status: "ready")
      |> assign(inc: 0)

    {:ok, socket}
  end

  def handle_event("increment", %{"inc" => inc}, socket) do
    inc = String.to_integer(inc)

    socket =
      socket
      |> assign(inc: inc + 1)

    {:noreply, socket}
  end

  def handle_event("decrement", %{"inc" => inc}, socket) do
    inc = String.to_integer(inc)

    socket =
      socket
      |> assign(inc: inc - 1)

    {:noreply, socket}
  end

  def handle_event(step, _value, socket) do
    text = @deployment_steps[step][:text]
    state = %{text: text, status: step}
    PubSub.broadcast_from(Nappy.PubSub, self(), @topic, step)
    {:noreply, assign(socket, state)}
  end

  def handle_info("done", socket) do
    {:noreply, assign(socket, text: "Done!", status: "done")}
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_info(step, socket) do
    Process.sleep(1_000)
    text = @deployment_steps[step][:text]
    next_step = @deployment_steps[step][:next_step]
    state = %{text: text, status: step}
    PubSub.broadcast_from(Nappy.PubSub, self(), @topic, next_step)
    {:noreply, assign(socket, state)}
  end
end
