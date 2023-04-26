let FileSaver = require('file-saver');

export default DownloadFile = {
  mounted() {
    document.querySelectorAll("button[id^='download-']").forEach(button => {
      button.addEventListener("click", e => {
        FileSaver.saveAs(button.value, "image.jpg")
      })
    })
  },
}
