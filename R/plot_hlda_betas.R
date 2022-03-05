

#' Visualizes Topic Composition of a Fitted hLDA Model
#'
#'
#' @param hLDA_model (required, \code{hLDA.model}) object returned by \code{hLDA}.
#' @param reorder_feature (optional, \code{logical}, default = \code{TRUE})
#' whether features should be re-ordered to group features belonging to the same
#' topics in the visualization of the topic composition.
#' @param min_p (optional, \code{real} in \code{]0,1[}, default = \code{0.01})
#' the proportion a feature must have in any topic to be included in the topic
#' composition visualization.
#' @param color_by (optional, \code{character}, default = "path") specifies the
#' variable that should be used for coloring the visualization.
#' @param print_legend (optional, \code{logical}, default = \code{FALSE})
#' whether a legend should be printed to the console.
#'
#' @return A \code{ggplot2} object describing the sample composition.
#'
#' @seealso plot_hLDA
#' @export
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @examples
#' x <- matrix(sample(0:100, 1000, replace = TRUE), 20, 50)
#' m <- hLDA(x, depth = 3)
#' plot_hLDA_betas(m)



plot_hLDA_betas <- function(hLDA_model, reorder_feature = TRUE, min_p = 0.01, color_by = "path", print_legend = FALSE){

  color_by2 <- match.arg(color_by, c("path","topic","feature"))
  if (color_by2 == "topic") color_by2 <- "topic_index"

  if (print_legend) {
    message(
      paste0(
        "Each row is a feature (word), each column is a topic.\n",
        "Color indicate the ", color_by,".\n",
        "Topics are arranged by path (vertical panels) and by depth within a path.\n",
        "Topics at shallower depth are repeated in vertical panels.\n",
        "The size of dots is proportional to the estimated frequency of the corresponding feature in a given topic.\n"

      )
    )
  }

  d <-
    left_join(
      get_paths(hLDA_model) ,
      hLDA_model@betas,
      by = "topic_index")  %>%
    rename(topic_path = path) %>%
    filter(p > min_p)  %>%
    left_join(
      .,
      hLDA_model@topics %>%
        select(topic_index, path),
      by = "topic_index")

  if(reorder_feature) {
    d <-
      d %>%
      arrange(depth, path, -p) %>%
      mutate(feature = feature %>% factor(., levels = unique(feature)))
  } else {
    d <- d %>%
      arrange(feature) %>%
      mutate(feature = feature %>% factor(., unique(feature)))
  }

  d <-
    d %>%
    mutate(x = topic_index, y = feature %>% forcats::fct_rev()) %>%
    rename(color = !!color_by2)

  ggplot(d,
         aes(x = x, y = y, col = color, size = p)) +
    geom_point() +
    scale_size("beta",limits = c(0,1), range = c(0,3)) +
    guides(col = "none", size = "none") +
    xlab("Topic index") +
    ylab("") +
    facet_grid(. ~ topic_path, scales = "free", space = "free")

  # ggplot(d,
  #        aes(x = topic_index, y = feature %>% fct_rev(), fill = path, alpha = p)) +
  #   geom_tile() +
  #   scale_alpha("beta",limits = c(0,1), range = c(0,1)) +
  #   guides(fill = "none", alpha = "none") +
  #   xlab("Topic index") +
  #   ylab("") +
  #   facet_grid(. ~ path, scales = "free", space = "free")

}


