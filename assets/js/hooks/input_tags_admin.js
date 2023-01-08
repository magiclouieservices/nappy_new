import Tagify from '@yaireo/tagify'

export default InputTagsAdmin = {
  mounted() {
    document.querySelectorAll("span[id*=modal-trigger]").forEach(el => {
      let inputTag = el.nextElementSibling.querySelector("input[name*=input-tags]")
      new Tagify(inputTag)
      // inputTag.classList.replace()
      // inputTag.classList.replace()
      // grow-0
      // min-w-[unset]
    })

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
}
