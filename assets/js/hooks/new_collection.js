export default NewCollection = {
  // loadMore(entries) {
  //   const target = entries[0];
  //   if (target.isIntersecting) {
  //     console.log("triggered");
  //     this.pushEvent("load-more", {});
  //   }
  // },
  mounted() {
    // this.observer = new IntersectionObserver(
    //   (entries) => this.loadMore(entries),
    //   {
    //     root: null, // window by default
    //     rootMargin: "400px",
    //     threshold: 0.1,
    //   }
    // );
    // this.observer.observe(this.el);

    let addToCollectionButton = document.querySelectorAll("[id^=new_collection-]")
    if (addToCollectionButton) {
      addToCollectionButton
      .forEach(el => {
          el.addEventListener("click", event => {
              event.preventDefault
              let inputValue = el.parentElement.previousElementSibling.value
              this.pushEvent("add_new_collection", {input: inputValue})
          })
      })
    }
  },
  // destroyed() {
  //   this.observer.unobserve(this.el);
  // },
};