import AdminClipboard from "./hooks/admin_clipboard"
import AdminSearch from "./hooks/admin_search"
import InfiniteScroll from "./hooks/infinite_scroll"
import BulkInputTagsAdmin from "./hooks/bulk_input_tags_admin"
import InputTagsAdmin from "./hooks/input_tags_admin"
import Multiselect from "./hooks/multiselect"
import MultiSelectTags from "./hooks/multi_select_tags"
import ViewCount from "./hooks/view_count"
import ThumbnailPicker from "./hooks/thumbnail_picker"

let Hooks = {
  AdminClipboard: AdminClipboard,
  AdminSearch: AdminSearch,
  InfiniteScroll: InfiniteScroll,
  BulkInputTagsAdmin: BulkInputTagsAdmin,
  InputTagsAdmin: InputTagsAdmin,
  Multiselect: Multiselect,
  MultiSelectTags: MultiSelectTags,
  ViewCount: ViewCount,
  ThumbnailPicker: ThumbnailPicker,
}

export default Hooks;
