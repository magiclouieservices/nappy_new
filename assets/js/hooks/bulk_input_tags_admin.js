import Tagify from '@yaireo/tagify'

export default BulkInputTagsAdmin = {
  mounted() {
    let inputTag = document.querySelector("input[name*=input-tags]")
    new Tagify(inputTag)

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
  updated() {
  },
}
