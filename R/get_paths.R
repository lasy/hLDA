get_paths <- function(hLDA_model){
  h <- hLDA_model@hierarchy
  purrr::map_dfr(
    .x = h$child_topic[h$child_depth == max(h$child_depth)],
    .f = function(l){
      dplyr::bind_cols(tibble(path = l), get_path_up(tibble(), h, l))
    }
  )

}

get_path_up <- function(itself, h, t){
  this_h <- h %>% filter(child_topic == t)
  if (nrow(itself) == 0) {
    itself = tibble::tibble(topic_index = t, depth = this_h$child_depth)
    }
  if (nrow(this_h) > 0) {
    itself <-
      bind_rows(
        itself,
        tibble::tibble(topic_index = this_h$parent_topic, depth = this_h$parent_depth)
      )
    itself <- get_path_up(itself, h = h, t = this_h$parent_topic)
  }
  itself
}
