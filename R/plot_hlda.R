


#' Visualizes the hLDA Model
#'
#' Specifically, \code{plot_hLDA} shows the hierarchy
#' (which can be visualized separately with \code{plot_hLDA_hierarchy}),
#' the topic composition (see \code{plot_hLDA_betas}), and the sample
#' composition (see \code{plot_hLDA_gammas} or \code{plot_hLDA_gammas_by_path}).
#'
#' @param hLDA_model (required, \code{hLDA.model}) object returned by \code{hLDA}.
#' @param reorder_feature (optional, \code{logical}, default = \code{TRUE})
#' whether features should be re-ordered to group features belonging to the same
#' topics in the visualization of the topic composition.
#' @param min_p (optional, \code{real} in \code{]0,1[}, default = \code{0.01})
#' the proportion a feature must have in any topic to be included in the topic
#' composition visualization.
#' @param title (optional, \code{character}, default = \code{""})
#' @param color_by (optional, \code{character}, default = \code{"path"}) specifies the
#' variable that should be used for coloring the visualization.
#'
#' @seealso plot_hLDA_hierarchy, plot_hLDA_betas, plot_hLDA_gammas
#' @export
#' @import ggplot2
#' @importFrom magrittr %>%
#' @importFrom ggpubr ggarrange
#' @examples
#' x <- matrix(sample(0:100, 1000, replace = TRUE), 20, 50)
#' m <- hLDA(x, depth = 3)
#' plot_hLDA(m)

plot_hLDA <- function(hLDA_model, reorder_feature = TRUE, min_p = 0.01, title = "", color_by = "path"){

  color_by <- match.arg(color_by, c("path","topic"))

  h_title <- "Topic hierarchy"
  if (title != "") h_title <- paste0("Topic hierarchy (",title,")")
  ggarrange(
    plot_hLDA_hierarchy(hLDA_model, direction = "v", color_by = color_by) +
      theme(plot.margin = margin(t = 20, r = -10, b = 10, l = 110, unit = "pt")) +
      ggtitle(h_title),
    ggarrange(
      plot_hLDA_betas(hLDA_model, reorder_feature = reorder_feature, min_p = min_p, color_by = color_by) +
        xlab("") +
        theme(axis.text.x = element_blank()) +
        ggtitle("Topic composition"),
      plot_hLDA_gammas(hLDA_model, color_by = color_by) + ylab("") +
        theme(axis.text.x = element_blank()) +
        ggtitle("Sample composition"),
      nrow = 2, ncol = 1,
      align = "v"
      ),
    nrow = 2, ncol = 1,
    heights = c(1, 4)
    #widths = c(2,1)
  )
}


