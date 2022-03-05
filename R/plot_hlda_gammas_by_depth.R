
plot_hLDA_gammas_by_depth <- function(hLDA_model){

  hLDA_gammas <- hLDA_model@gammas

  ggplot(hLDA_gammas,
         aes(x = topic_index, y = d, fill = path, alpha = topic_prop)) +
    geom_tile() +
    facet_grid(. ~ depth, scales = "free", space = "free") +
    guides(fill = "none") +
    scale_alpha(range = c(0,1), limits = c(0,1))
}
