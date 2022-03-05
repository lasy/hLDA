#' @importFrom magrittr %>%
get_hLDA_hierarchy <- function(hLDA_model) {
  d <-  0
  topic_indices <-  0L
  h <-  tibble::tibble()
  while (d < (hLDA_model$depth-1)) {
    for (topic_index in topic_indices) {
      children_topics <- hLDA_model$children_topics(topic_index) %>% as.integer()
      h <-
        dplyr::bind_rows(
          h,
          tibble::tibble(
            parent_topic = topic_index,
            child_topic = children_topics,
            parent_depth = d,
            child_depth = d+1
          )
        )
    }
    topic_indices <- h$child_topic[h$parent_depth == d]
    d <- d + 1
  }
  live_topics_in_order <- go_down_the_tree(0, h)
  h <-
    h %>%
    dplyr::arrange(parent_depth, parent_topic, child_topic) %>%
    dplyr::mutate(
      parent_topic = parent_topic %>% factor(., levels = live_topics_in_order),
      child_topic = child_topic %>% factor(., levels = live_topics_in_order)
    )
  h
}


#' @importFrom magrittr %>%
go_down_the_tree <- function(t, h){
  c(t,
    purrr::map(
      .x = h$child_topic[h$parent_topic == t] %>% sort(),
      .f = function(x) go_down_the_tree(x, h)
    )
  ) %>%
    unlist()

}
