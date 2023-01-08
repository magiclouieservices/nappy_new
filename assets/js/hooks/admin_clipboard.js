export default AdminClipboard = {
  mounted() {
    document.querySelectorAll(".copy-button").forEach(item => {
      item.addEventListener("click", () => {
        const embedText = item.nextElementSibling.value
        const clipboard = item.querySelector("svg path")
        const clipboard_icon = clipboard.getAttribute("d")
        const check_icon = "M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.094 1.976 1.057 1.976 2.192V16.5A2.25 2.25 0 0118 18.75h-2.25m-7.5-10.5H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V18.75m-7.5-10.5h6.375c.621 0 1.125.504 1.125 1.125v9.375m-8.25-3l1.5 1.5 3-3.75"
        const error_icon = "M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z"

        navigator.clipboard.writeText(embedText)
          .then(() => {
            clipboard.setAttribute("d", check_icon)
            setTimeout(() => clipboard.setAttribute("d", clipboard_icon), 2000)
          }).catch((error) => {
            clipboard.setAttribute("d", error_icon)
            setTimeout(() => clipboard.setAttribute("d", clipboard_icon), 2000)
          });
      })
    })
  },
}
