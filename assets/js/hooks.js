import Clipboard from "./hooks/clipboard"
import AdminSearch from "./hooks/admin_search"
import InfiniteScroll from "./hooks/infinite_scroll"
import InputTagsAdmin from "./hooks/input_tags_admin"
import InputTags from "./hooks/input_tags"
import Multiselect from "./hooks/multiselect"
import MultiSelectTags from "./hooks/multi_select_tags"
import ViewCount from "./hooks/view_count"
import ThumbnailPicker from "./hooks/thumbnail_picker"
import DownloadFile from './hooks/download_file'
import NewCollection from './hooks/new_collection'

let Hooks = {
  Clipboard: Clipboard,
  AdminSearch: AdminSearch,
  InfiniteScroll: InfiniteScroll,
  InputTagsAdmin: InputTagsAdmin,
  InputTags: InputTags,
  Multiselect: Multiselect,
  MultiSelectTags: MultiSelectTags,
  ViewCount: ViewCount,
  ThumbnailPicker: ThumbnailPicker,
  DownloadFile: DownloadFile,
  NewCollection: NewCollection,
}

export default Hooks;
