import Tagify from '@yaireo/tagify'

export default InputTagsAdmin = {
  mounted() {
    document.querySelectorAll("span[id*=modal-trigger]").forEach(el => {
      let inputTag = el.nextElementSibling.querySelector("input[name*=input-tags]")
      new Tagify(inputTag)
    })

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
}
