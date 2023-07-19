export default MultiSelectTags = {
  mounted() {
    this.el.addEventListener("keyup", (e) => {
      if (e.code == "Comma") {
        // let tags = e.target.value.replace(/\s+/g, "");
        let tags = e.target.value;
        tags.split(",").forEach((tag) => {
          if (tag.length > 0) {this.pushEvent("add_tag", tag)}
        });
        e.target.value = "";
      }
    });
  },
}
