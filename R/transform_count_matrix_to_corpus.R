#' @import magrittr
#' @importFrom magrittr %>%
transform_count_matrix_to_corpus <-  function(data){
  if (is.null(colnames(data))) {
    warning(
      paste0("The column names (the features) were not provided.
             Replacing them with 'w1'...'w",ncol(data),"'\n")
    )
    colnames(data) <- paste0("w", 1:ncol(data))
  }
  purrr::map_dfr(
    .x = 1:nrow(data),
    .f = function(i) {
      rep(colnames(data), data[i,]) %>%
        sample() %>% # for fun
        stringr::str_c(., collapse = " ") %>%
        tibble::as_tibble()
    }
  )
}
