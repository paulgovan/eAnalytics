library(testthat)
library(shinytest)

testthat::test_that("Application works", {
  shinytest::expect_pass(shinytest::testApp("inst/app", "mytest", quiet = TRUE, compareImages = FALSE))
})
