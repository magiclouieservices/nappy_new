export default Multiselect = {
  mounted() {
    let tableRows = document.querySelectorAll(".select-images")
    let checkboxes = document.querySelectorAll("input[name*=select_]")
    let groupSelect = document.querySelector("#group-select")

    // clicking table row(s) for selecting image(s)
    tableRows.forEach(row => {
      row.addEventListener("click", e => {
        // target parent elements only (table rows)
        if (e.target.id.includes("modal-trigger") ||
            e.target.id.includes("modal-thumbnail-trigger")) {
          return
        } else {
          row
            .querySelector("td")
            .querySelectorAll("input").forEach(checkbox => {
              checkbox.checked = checkbox.checked ? false : true
          })
          row.classList.toggle("bg-gray-300")
        }
      })
    })

    // tick icon not displaying regardless if clicked
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener("click", e => {
        checkbox.checked = checkbox.checked ? false : true
      })
    })

    // #group-select for mass tick/untick
    groupSelect.addEventListener("click", e => {
      if (groupSelect.checked) {
        checkboxes.forEach(checkbox => {checkbox.checked = true})
        tableRows.forEach(row => {row.classList.add("bg-gray-300")})
      } else {
        checkboxes.forEach(checkbox => {checkbox.checked = false})
        tableRows.forEach(row => {row.classList.remove("bg-gray-300")})
      }
    })
  },
}
