
#' @importFrom magrittr %>%
get_hLDA_betas <- function(hLDA_model) {

  K <- hLDA_model$k
  features <- get_hLDA_features(hLDA_model)
  betas <- matrix(NA, nrow = K, ncol = length(features))

  for (k in 1:K) {
    topic_index <- (k-1) %>% as.integer()
    if (hLDA_model$is_live_topic(topic_index)) {
      betas[k, ] <- hLDA_model$get_topic_word_dist(topic_index)
    }
  }

  betas <-
    betas %>%
    magrittr::set_colnames(features) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(topic_index = dplyr::row_number() - 1) %>%
    tidyr::pivot_longer(
      cols = -topic_index,
      names_to = "feature",
      values_to = "p"
    ) %>%
    dplyr::filter(!is.na(p)) %>%
    dplyr::mutate(topic_index = topic_index %>% factor())

  betas
}
