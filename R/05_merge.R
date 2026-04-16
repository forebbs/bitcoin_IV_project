dir.create("data_clean", showWarnings = FALSE)

btc <- readRDS("data_clean/btc_weekly.rds")
cost <- readRDS("data_clean/mining_cost_weekly.rds")
energy <- readRDS("data_clean/energy_instruments.rds")
vix <- readRDS("data_clean/vix_weekly.rds")
treasury <- readRDS("data_clean/treasury_weekly.rds")
sp500 <- readRDS("data_clean/sp500_weekly.rds")

df <- btc %>%
  inner_join(cost, by = "week") %>%
  arrange(week) %>%
  mutate(
    ln_mining_cost_lag1 = lag(ln_mining_cost, 1)
  ) %>%
  inner_join(
    energy %>% select(week, ln_oil_lag1, ln_oil_lag2),
    by = "week"
  ) %>%
  inner_join(vix %>% select(week, vix_lag1), by = "week") %>%
  inner_join(treasury %>% select(week, treasury_lag1), by = "week") %>%
  inner_join(sp500 %>% select(week, sp500_return_lag1), by = "week")

df_final <- df %>%
  arrange(week) %>%
  filter(
    !is.na(ln_btc),
    !is.na(ln_mining_cost_lag1),
    !is.na(ln_oil_lag1),
    !is.na(ln_oil_lag2),
    !is.na(vix_lag1),
    !is.na(treasury_lag1),
    !is.na(sp500_return_lag1)
  ) %>%
  select(
    week,
    ln_btc,
    ln_mining_cost_lag1,
    sp500_return_lag1,
    vix_lag1,
    treasury_lag1,
    ln_oil_lag1,
    ln_oil_lag2
  )

saveRDS(df_final, "data_clean/final_dataset.rds")

cat("Observations:", nrow(df_final), "\n")
print(names(df_final))
print(colSums(is.na(df_final)))

saveRDS(df, "data_clean/final_dataset.rds")
write.csv(df, "data_clean/final_dataset.csv", row.names = FALSE)