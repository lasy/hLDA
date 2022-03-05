

#' Fits a hLDA Model to Count Data
#'
#' @param x a matrix of counts.
#' Features are on columns and samples are on rows.
#' @param depth (required, \code{integer}) the desired depth of the
#' hierarchical structure.
#' @param gamma (optional, \code{real} in \code{]0,1[}, default = \code{0.1})
#' the concentration parameter for introducing new topics.
#' @param alpha (optional, \code{real} in  \code{]0,1[}, default = \code{0.1})
#' hyperparameter of Dirichlet distribution for document-depth level.
#' @param eta (optional, \code{real} in \code{]0,1[}, default = \code{0.1})
#' hyperparameter of Dirichlet distribution for topic-word.
#' @param print (optional, \code{character}, default = \code{"nothing"}) What
#' should be printed to the console?
#'
#' @return a \code{hLDA.model} object.
#'
#' @export
#' @importFrom magrittr %>%
#' @examples
#' x <- matrix(sample(0:100, 1000, replace = TRUE), 20, 50)
#' m <- hLDA(x, depth = 3)
#' plot_hLDA(m)


hLDA <- function(x, depth, gamma = 0.1, alpha = 0.1, eta = 0.1,
                 print = c("nothing","summary", "everything"))
{

  # 1. Inputs
  stopifnot(
    all(x >= 0), all(round(x) == x),
    depth > 0, round(depth) == depth,
    (gamma > 0) & (gamma < 1),
    is.character(print)
    )
  print <- match.arg(print[1], c("nothing","summary", "everything"))


  # 2. files
  run_id <- as.integer(Sys.time())
  tmp_data_file <- paste0("corpus_data_", run_id, ".txt")
  if (file.exists(tmp_data_file))  file.remove(tmp_data_file)

  # 3. preparing data
  x_as_corpus <- transform_count_matrix_to_corpus(x)
  readr::write_csv(x_as_corpus, file = tmp_data_file, col_names = FALSE)

  # 4. fit the hLDA
  model <-
    .env$fit_hLDA$fit_hLDA(
      tmp_data_file,
      depth = depth %>% as.integer(),
      gamma = gamma, alpha = alpha, eta = eta,
      print_all = ifelse(print == "everything", TRUE, FALSE),
      print_summary = ifelse(print != "nothing", TRUE, FALSE)
    )
  file.remove(tmp_data_file)

  # 5. Export hLDA model from python to R hLDA class
  hLDA_class_model <- get_hLDA(model)
  # list(r_model = hLDA_class_model, tp_model = model)
  hLDA_class_model

}


#' hLDA Class Definition
#'
#' The hLDA class contains information associated with a hierarchical LDA model.
#' The available accessor methods are,
#'
#' * \code{gammas}: Extract the sample composition.
#' * \code{betas}: Extract the topic composition.
#' * \code{topics}: Extract the topic information.
#' * \code{hierarchy}: Extract the hierarchical structure.
#' * \code{par}: Returns the parameters used for model fitting.
#'
#' @seealso hLDA
#' @import methods
#' @exportClass hLDA.model
setClass("hLDA.model",
         representation(
           topics = "data.frame",
           hierarchy = "data.frame",
           betas = "data.frame",
           gammas = "data.frame",
           par = "list"
         )
)


#' @importFrom methods new
get_hLDA <- function(model){
  new(
    "hLDA.model",
    topics = get_hLDA_topic_characteristics(model),
    hierarchy = get_hLDA_hierarchy(model),
    betas = get_hLDA_betas(model),
    gammas = get_hLDA_gammas(model),
    par = get_hLDA_par(model)
  )
}
