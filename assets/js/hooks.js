import AdminClipboard from "./hooks/admin_clipboard"
import AdminSearch from "./hooks/admin_search"
import InfiniteScroll from "./hooks/infinite_scroll"
import InputTagsAdmin from "./hooks/input_tags_admin"
import Multiselect from "./hooks/multiselect"
import ViewCount from "./hooks/view_count"

let Hooks = {
  AdminClipboard: AdminClipboard,
  AdminSearch: AdminSearch,
  InfiniteScroll: InfiniteScroll,
  InputTagsAdmin: InputTagsAdmin,
  Multiselect: Multiselect,
  ViewCount: ViewCount,
}

export default Hooks;
