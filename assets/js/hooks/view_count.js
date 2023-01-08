export default ViewCount = {
  slug() {return this.el.dataset.slug;},
  incrementViewCount(entries) {
    const target = entries[0];
    if (target.isIntersecting) {
      this.pushEvent("increment_view_count", {slug: this.slug()});
    }
  },
  mounted() {
    this.observer = new IntersectionObserver(
      (entries) => this.incrementViewCount(entries),
      {
        root: null, // window by default
        rootMargin: "0px",
        threshold: 1.0,
      }
    );
    this.observer.observe(this.el);
  },
  destroyed() {
    this.observer.unobserve(this.el);
  },
};
