dir.create("data_clean", showWarnings = FALSE)

start_date <- as.Date("2016-01-01")
end_date   <- as.Date("2025-12-31")

# Bitcoin
btc_daily <- getSymbols(
  "BTC-USD",
  src = "yahoo",
  auto.assign = FALSE
)

btc_df <- data.frame(
  date = as.Date(index(btc_daily)),
  btc_price = as.numeric(Cl(btc_daily))
) %>%
  filter(!is.na(btc_price)) %>%
  filter(date >= start_date & date <= end_date) %>%
  arrange(date)

btc_weekly <- btc_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(
    btc_price = mean(btc_price)
  ) %>%
  ungroup() %>%
  arrange(week) %>%
  mutate(
    ln_btc = log(btc_price)
  )

saveRDS(btc_weekly, "data_clean/btc_weekly.rds")