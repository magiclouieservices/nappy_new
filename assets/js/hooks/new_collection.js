export default NewCollection = {
  mounted() {
    let addToCollectionButton = document.querySelectorAll("[id^=new_collection-]")

    if (addToCollectionButton) {
      addToCollectionButton
      .forEach(el => {
        let input = el.parentElement.previousElementSibling

        input.addEventListener("input", event => {
          if (!!event.target.value) {
            el.removeAttribute("disabled")
            el.classList.replace("bg-gray-500", "bg-black")
            el.classList.add("hover:bg-gray-900")
          } else {
            el.setAttribute("disabled", "")
            el.classList.replace("bg-black", "bg-gray-500")
            el.classList.remove("hover:bg-gray-900")
          }
        })

        el.addEventListener("click", event => {
          event.preventDefault()

          if (!!input.value) {
            this.pushEvent("add_new_collection", {input: input.value})
          }
        })
      })
    }
  },
};