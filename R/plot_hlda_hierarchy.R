

#' Visualizes the Topic Hierarchy of a Fitted hLDA Model
#'
#' @param hLDA_model (required, \code{hLDA.model}) object returned by \code{hLDA}.
#' @param direction (optional, \code{character}, default = \code{"h"})
#' whether the hierarchy should be displayed vertically (\code{"v"}) or horizontally (\code{"h"}).
#' @param color_by (optional, \code{character}, default = \code{"path"}) specifies the
#' variable that should be used for coloring the visualization.
#'
#' @return A \code{ggplot2} object describing the sample composition.
#'
#' @seealso plot_hLDA
#' @export
#' @import dplyr
#' @import ggplot2
#' @import ggraph
#' @importFrom magrittr %>%
#' @importFrom igraph V
#' @examples
#' x <- matrix(sample(0:100, 1000, replace = TRUE), 20, 50)
#' m <- hLDA(x, depth = 3)
#' plot_hLDA_hierarchy(m)


plot_hLDA_hierarchy <- function(hLDA_model, direction = "h", color_by = "path"){

  color_by2 <- match.arg(color_by, c("path","topic"))
  if (color_by2 == "topic") color_by2 <- "topic_index"

  h <- hLDA_model@hierarchy
  gh <- igraph::graph_from_data_frame(h)
  igraph::V(gh)$topic_index <- names(igraph::V(gh))
  topics <- hLDA_model@topics
  m <- match(igraph::V(gh)$topic_index, topics$topic_index)
  igraph::V(gh)$path <- topics$path[m]
  igraph::V(gh)$n_docs <- topics$n_docs[m]

  if (color_by2 == "topic")  igraph::V(gh)$color <- igraph::V(gh)$topic_index
  if (color_by2 == "path")  igraph::V(gh)$color <-  igraph::V(gh)$path

  layout <- igraph::layout.reingold.tilford(gh)
  if (direction == "h") { layout <- -layout[,2:1] }
  ggraph::ggraph(gh, layout = layout) +
    ggraph::geom_edge_link(color = "gray50") +
    ggraph::geom_node_label(ggplot2::aes(size = n_docs, label = topic_index, fill = color %>% factor()), color = "white") +
    ggplot2::guides(col = "none", size = "none", fill = "none") +
    ggplot2::scale_size("# of samples", range = c(2,6)) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin =  ggplot2::margin(t = 10, r = 10, b = 20, l = 20, unit = 'pt'))

}
