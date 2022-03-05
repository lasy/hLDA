get_hLDA_par <- function(model){
  list(
    depth = model$depth,
    gamma = model$gamma,
    alpha = model$alpha,
    eta = model$eta,
    k = model$k,
    live_k = model$live_k,
    n_features = model$num_vocabs,
    total_counts = model$num_words,
    perplexity = model$perplexity
  )
}
