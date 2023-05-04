import Tagify from '@yaireo/tagify'

export default InputTags = {
  mounted() {
    let inputTag = document.querySelector("input[name*=input-tags]")
    var tagify = new Tagify(inputTag, {
        callbacks: {
        "focus": (e) => console.log(e.detail)
      }
    })

    document.querySelectorAll(".close-modal").forEach(el => {
      el.addEventListener("click", () => {
        const tags = el.value
        tagify.loadOriginalValues(tags)
      })
    })

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
}
