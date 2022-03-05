#' @importFrom magrittr %>%
get_hLDA_features <- function(hLDA_model, all = FALSE) {
  if (all) v <- hLDA_model$vocabs else v <- hLDA_model$used_vocabs
  v %>%
    as.character() %>%
    stringr::str_remove("\\[") %>%
    stringr::str_remove("\\]") %>%
    stringr::str_remove_all("'") %>%
    stringr::str_split(., ", ") %>%
    unlist()
}

