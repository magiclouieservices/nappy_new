// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Hooks from "./hooks"
import Alpine from 'alpinejs'
import focus from '@alpinejs/focus'
import collapse from '@alpinejs/collapse'

window.Alpine = Alpine
Alpine.plugin(focus)
Alpine.plugin(collapse)
Alpine.start()


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
	hooks: Hooks,
  params: {_csrf_token: csrfToken},
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to)
      }
    }
  }
})

window.zoom = function (e) {
  var zoomer = e.currentTarget;
  e.offsetX ? offsetX = e.offsetX : offsetX = e.pageX
  e.offsetY ? offsetY = e.offsetY : offsetX = e.pageX
  x = offsetX/zoomer.offsetWidth*100
  y = offsetY/zoomer.offsetHeight*100
  zoomer.style.backgroundPosition = x + '% ' + y + '%';
}

window.toggleFullscreen = function (selector) {
  const elems = document.querySelectorAll(selector)
  elems.forEach(elem => {
    let parentElement = elem.parentElement

    if (parentElement.classList.contains("hover:cursor-zoom-in")) {
      parentElement.classList.replace("hover:cursor-zoom-in", "hover:cursor-zoom-out")
      parentElement.removeAttribute("onmousemove")
    } else {
      parentElement.classList.replace("hover:cursor-zoom-out", "hover:cursor-zoom-in")
      parentElement.setAttribute("onmousemove", "window.zoom(event)")
    }

    elem.nextElementSibling.classList.toggle("hidden")
    elem.classList.toggle("hidden")
  })
}
window.reset_tags = function (tagify, tags) {
  tagify.loadOriginalValues(tags)
}

// Show progress bar on live navigation and form submits
// topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
topbar.config({barColors: {0: "#000"}})
window.addEventListener("phx:page-loading-start", _info => topbar.show())
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
