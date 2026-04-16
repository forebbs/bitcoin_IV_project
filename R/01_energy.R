dir.create("data_clean", showWarnings = FALSE)
dir.create("data_raw", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)

start_date <- as.Date("2016-01-01")
end_date   <- as.Date("2025-12-31")

# Oil
dir.create("data_clean", showWarnings = FALSE)

start_date <- as.Date("2016-01-01")
end_date   <- as.Date("2025-12-31")

# Oil
oil_daily <- getSymbols(
  "CL=F",
  src = "yahoo",
  auto.assign = FALSE
)

oil_df <- data.frame(
  date = as.Date(index(oil_daily)),
  oil_price = as.numeric(Cl(oil_daily))
) %>%
  filter(!is.na(oil_price)) %>%
  filter(date >= start_date & date <= end_date)

oil_weekly <- oil_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(oil_price = mean(oil_price)) %>%
  ungroup() %>%
  arrange(week)

# Log + Lag (IVs)
energy_weekly <- oil_weekly %>%
  mutate(
    ln_oil = log(oil_price),
    ln_oil_lag1 = lag(ln_oil, 1),
    ln_oil_lag2 = lag(ln_oil, 2)
  ) %>%
  filter(
    !is.na(ln_oil_lag1),
    !is.na(ln_oil_lag2)
  )

saveRDS(energy_weekly, "data_clean/energy_instruments.rds")