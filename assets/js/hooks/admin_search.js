export default AdminSearch = {
  mounted() {
    // prevent clicking search button when input is empty
    document
      .getElementById("admin-search-button")
      .addEventListener("click", e => {
        let input = document.getElementById("admin-search").value.replace(/\s+/g, "")

        if (input == "") {
          e.preventDefault()
          return false
        }
    })

    // prevent enter button when input is empty
    document
      .getElementById("admin-search")
      .addEventListener("keydown", e => {
      let input = e.target.value.replace(/\s+/g, "")

      if (input == "") {
        if (e.keyIdentifier == "U+000A" || e.keyIdentifier == "Enter"|| e.keyCode == 13) {
          if (e.target.nodeName == "INPUT" && e.target.type == "text") {
            e.preventDefault()
            return false
          }
        }
      }
    })
  },
}
