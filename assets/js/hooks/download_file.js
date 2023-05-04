let FileSaver = require('file-saver');

export default DownloadFile = {
  mounted() {
    document.querySelectorAll("button[id^='download-']").forEach(button => {
      const name = button.getAttribute("name")
      button.addEventListener("click", e => {
        FileSaver.saveAs(button.value, `${name}`)
      })
    })
  },
}
