export default ThumbnailPicker = {
  mounted() {
    buttons = document.querySelectorAll("#thumbnail-picker button")

    buttons.forEach(button => {
      button.addEventListener("click", () => {
        buttons.forEach(button => {
          button.querySelector("span").classList.add("hidden")
          button.querySelector("div").classList.remove("bg-[rgba(0,0,0,0.5)]")
        })
        button.querySelector("input").checked = true
        button.querySelector("span").classList.remove("hidden")
        button.querySelector("div").classList.add("bg-[rgba(0,0,0,0.5)]")
      })
    })
  },
}
