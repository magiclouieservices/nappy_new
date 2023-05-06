import Tagify from '@yaireo/tagify'

export default InputTags = {
  mounted() {
    let inputTag = document.querySelector("input[name*=input-tags]")
    var tagify = new Tagify(inputTag)

    window.resetTags = tags => tagify.loadOriginalValues(tags)

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
}
