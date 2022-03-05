#' @importFrom magrittr %>%
get_hLDA_topic_characteristics <- function(hLDA_model){

  h <- get_hLDA_hierarchy(hLDA_model)
  topics <-
    h %>%
    dplyr::filter(child_depth == max(child_depth)) %>%
    dplyr::select(child_topic, child_depth) %>%
    dplyr::mutate(path = child_topic) %>%
    dplyr::rename(topic_index = child_topic, depth = child_depth)

  for (d in max(h$parent_depth):0) {
    topics <-
      topics %>%
      dplyr::bind_rows(
        .,
        h %>%
          dplyr::filter(parent_depth == d) %>%
          dplyr::rename(topic_index = child_topic) %>%
          dplyr::left_join(., topics, by = "topic_index") %>%
          dplyr::select(parent_topic, path, parent_depth) %>%
          dplyr::group_by(parent_topic) %>%
          dplyr::slice_head(n = 1) %>%
          dplyr::ungroup() %>%
          dplyr::rename(topic_index = parent_topic,
                 depth = parent_depth)
      )
  }
  topics %>%
    dplyr::arrange(topic_index) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      n_docs =
        hLDA_model$num_docs_of_topic(
          topic_index %>% as.character() %>% as.integer()
        )
    ) %>%
    dplyr::ungroup()
}
