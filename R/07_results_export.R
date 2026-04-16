install.packages(c("stargazer", "modelsummary", "readr"))
library(modelsummary)

# OLS and IV models
models <- list(
  "OLS" = ols_model,
  "IV"  = iv_model
)

modelsummary(
  models,
  output = "output/regression_table.html",
  stars = TRUE
)
library(stargazer)

stargazer(
  ols_model,
  iv_model,
  type = "html",
  out = "output/regression_table.html",
  title = "Regression Results",
  dep.var.labels = "Log Bitcoin Price",
  covariate.labels = c(
    "Log Mining Cost (t-1)",
    "S&P 500 Return (t-1)",
    "VIX (t-1)",
    "Treasury Yield (t-1)"
  )
)