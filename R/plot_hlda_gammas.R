

#' Visualizes Sample (Document) Composition of a Fitted hLDA Model
#'
#'
#' @param hLDA_model (required, \code{hLDA.model}) object returned by \code{hLDA}.
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
#'

#' @examples
#' x <- matrix(sample(0:100, 1000, replace = TRUE), 20, 50)
#' m <- hLDA(x, depth = 3)
#' plot_hLDA_gammas(m)

plot_hLDA_gammas <- function(hLDA_model, color_by = "path", print_legend = FALSE){

  color_by2 <- match.arg(color_by, c("path","topic","sample"))
  if (color_by2 == "topic") color_by2 <- "topic_index"
  if (color_by2 == "sample") color_by2 <- "d"

  if (print_legend) {
    message(
      paste0(
        "Each row is a sample (document), each column is a topic. Color indicate the ",
        color_by,". Topics are arranged by path (vertical panels) and by depth within a path.
        Topics at shallower depth are repeated in vertical panels. The intensity of the color
        in each rectangle is proportional to the estimated proportion of the corresponding
        topic in a given document."
      )
    )
  }

  hLDA_gammas <-
    hLDA_model@gammas %>%
    arrange(d_index, -depth) %>%
    group_by(d_index) %>%
    mutate(document_path = path[1],
           average_depth = sum(topic_prop * depth)) %>%
    ungroup() %>%
    arrange(document_path, average_depth) %>%
    mutate(
      d = d %>% factor(., levels = unique(d)),
      x = topic_index,
      y = d %>% forcats::fct_rev()
    ) %>%
    rename(color = !!color_by2)

  ggplot(
    hLDA_gammas,
    aes(x = x, y = y, fill = color, alpha = topic_prop)
  ) +
    geom_tile() +
    ylab("samples") +
    xlab("Topic index/depth") +
    scale_y_discrete(breaks = NULL) +
    guides(fill = "none", alpha = "none") +
    scale_alpha(range = c(0,1), limits = c(0,1)) +
    facet_grid(. ~  document_path, space = "free", scales = "free")   # +
  # scale_fill_manual(
  #   "depth of topic",
  #   values = colorRampPalette(c("rosybrown1", "black"))(max(hLDA_gammas$depth)+1)
  # )



}
