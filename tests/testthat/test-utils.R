test_that("Messages", {
  skip_on_cran()
  expect_silent(make_msg(verbose = FALSE))
  expect_snapshot(make_msg(
    "generic",
    TRUE,
    "Hi",
    "I am a generic.",
    "See {.var avar}."
  ))
  expect_snapshot(make_msg("info", TRUE, "Info here.", "See {.pkg igoR}."))

  expect_snapshot(make_msg(
    "warning",
    TRUE,
    "Caution! A warning.",
    "But still OK."
  ))

  expect_snapshot(make_msg("danger", TRUE, "OOPS!", "I did it again :("))

  expect_snapshot(make_msg("success", TRUE, "Hooray!", "5/5 ;)"))
})
