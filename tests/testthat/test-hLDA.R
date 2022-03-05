test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


test_that("hLDA returns an hLDA.model object", {
  set.seed(1)
  N = 20; M = 10
  x <- matrix(sample(0:100, N*M, replace = TRUE), M, N)
  colnames(x) <- paste0("w",1:N)
  m <- hLDA(x, depth = 3)
  expect_equal(class(m) %>% as.character(), "hLDA.model")
})
