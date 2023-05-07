import Tagify from '@yaireo/tagify'

export default InputTags = {
  mounted() {
    let inputTag = document.querySelector("input[name*=input-tags]")
    var tagify = new Tagify(inputTag, {
      maxTags: 20
    })

    inputTag.addEventListener("change", function(event) {
        const defaultValue = event.target.defaultValue
        let currentValue = tagify.getCleanValue().map(obj => obj.value).toString()
        let relatedTags = document.querySelectorAll("[id^='confirm-update-related_tags']")
        if (currentValue !== defaultValue) {
          relatedTags.forEach(el => {
            el.setAttribute("phx-submit", "update_related_tags")
            el.removeAttribute("disabled")
          })
        } else {
          relatedTags.forEach(el => {
            el.removeAttribute("phx-submit", "update_related_tags")
            el.setAttribute("disabled", "disabled")
          })
        }
    })

    window.resetTags = tags => tagify.loadOriginalValues(tags)

    document.querySelectorAll("tags").forEach(el => {
      el.classList.add("flex")
    })
  },
}
