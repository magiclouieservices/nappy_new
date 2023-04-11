export default ThumbnailPicker = {
  mounted() {
    buttons = document.querySelectorAll("#thumbnail-picker button")

    buttons.forEach(button => {
      button.addEventListener("click", () => {
        button.querySelector("input").checked = true
      })
    })
  },
}
