dir.create("output", showWarnings = FALSE)
df <- readRDS("data_clean/final_dataset.rds")

nw_lag <- 6

# OLS
ols_model <- lm(
  ln_btc ~ ln_mining_cost_lag1 + sp500_return_lag1 + vix_lag1 + treasury_lag1,
  data = df
)

cat("\n OLS (Newey-West) \n")
print(coeftest(
  ols_model,
  vcov = NeweyWest(ols_model, lag = nw_lag, prewhite = FALSE, adjust = TRUE)
))

# First Stage
first_stage <- lm(
  ln_mining_cost_lag1 ~
    ln_oil_lag1 + ln_oil_lag2 +
    sp500_return_lag1 + vix_lag1 + treasury_lag1,
  data = df
)

cat("\ First Stage (Newey-West) \n")
print(coeftest(
  first_stage,
  vcov = NeweyWest(first_stage, lag = nw_lag, prewhite = FALSE, adjust = TRUE)
))

cat("\n First Stage F Test \n")
fs_f_test <- linearHypothesis(
  first_stage,
  c(
    "ln_oil_lag1 = 0",
    "ln_oil_lag2 = 0"
  )
)
print(fs_f_test)

# IV
iv_model <- ivreg(
  ln_btc ~ ln_mining_cost_lag1 + sp500_return_lag1 + vix_lag1 + treasury_lag1 |
    sp500_return_lag1 + vix_lag1 + treasury_lag1 +
    ln_oil_lag1 + ln_oil_lag2,
  data = df
)

cat("\n IV (Newey-West) \n")
print(coeftest(
  iv_model,
  vcov = NeweyWest(iv_model, lag = nw_lag, prewhite = FALSE, adjust = TRUE)
))

cat("\n IV Diagnostics \n")
print(summary(iv_model, diagnostics = TRUE))

cat("\n IV, Heteroskedastic Robust Errors \n")
print(coeftest(
  iv_model,
  vcov = vcovHC(iv_model, type = "HC1")
))

cat("\n Comparison of Coefficients \n")
cat("OLS:\n")
print(coef(ols_model)["ln_mining_cost_lag1"])
cat("IV:\n")
print(coef(iv_model)["ln_mining_cost_lag1"])

saveRDS(ols_model, "output/ols_model.rds")
saveRDS(first_stage, "output/first_stage_model.rds")
saveRDS(iv_model, "output/iv_model.rds")
write.csv(coef(summary(iv_model)),
          "output/iv_results.csv")
write.csv(coef(ols_model), "output/ols_coefficients.csv")
write.csv(df, "output/final_dataset.csv", row.names = FALSE)