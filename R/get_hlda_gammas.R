#' @importFrom magrittr %>%
get_hLDA_gammas <- function(hLDA_model) {

  is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol

  d <- hLDA_model$docs
  gammas <- tibble::tibble()
  i <- 0
  while(tryCatch(d[i]$path[1] %>% is.wholenumber(), error = function(e) FALSE)){
    path <- d[i]$path %>% as.vector()
    topic_props <- d[i]$get_topic_dist() %>% as.vector()
    gammas <-
      dplyr::bind_rows(
        gammas,
        tibble::tibble(
          d_index = i, d = i+1,
          topic_index = path,
          topic_prop = topic_props
        )
      )
    i <-  i+1
  }


  topic_characteristics <- get_hLDA_topic_characteristics(hLDA_model)
  gammas <-
    gammas %>%
    dplyr::mutate(
      topic_index =
        topic_index %>%
        factor(., levels = topic_characteristics$topic_index %>% levels())
    )

  gammas <-
    gammas %>%
    dplyr::left_join(., topic_characteristics, by = "topic_index")

  gammas
}


