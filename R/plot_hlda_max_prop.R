

plot_hLDA_max_prop <- function(hLDA_model) {
  hLDA_gammas <- hLDA_model@gammas

  hLDA_gammas %>%
    dplyr::arrange(d, -topic_prop) %>%
    dplyr::group_by(d) %>%
    dplyr::slice_head(n = 1) %>%
    ggplot2::ggplot(., aes(x = topic_prop, fill = depth %>% factor())) +
    ggplot2::geom_histogram(breaks = seq(1/hLDA_model@par$depth, 1, by = 0.025)) +
    ggplot2::geom_vline(xintercept = 1/hLDA_model@par$depth, linetype = 2, col = "gray50") +
    ggplot2::annotate(geom = "text", x = 1/hLDA_model@par$depth + 0.005, y = Inf,
             label = "smallest possible value", col = "gray50",
             hjust = 0, vjust = 1) +
    ggplot2::xlab("max topic prop. per sample") +
    ggplot2::ylab("# of samples") +
    ggplot2::scale_fill_manual(
      "depth of topic",
      values =
        grDevices::colorRampPalette(
          c("rosybrown1", "black")
          )(max(hLDA_gammas$depth)+2)
    )
}
