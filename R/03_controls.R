dir.create("data_clean", showWarnings = FALSE)

start_date <- as.Date("2016-01-01")
end_date   <- as.Date("2025-12-31")

dir.create("data_clean", showWarnings = FALSE)

# Timeframe
start_date <- as.Date("2016-01-01")
end_date   <- as.Date("2025-12-31")

# VIX
vix_daily <- getSymbols("^VIX", src = "yahoo", auto.assign = FALSE)

vix_df <- data.frame(
  date = as.Date(index(vix_daily)),
  vix = as.numeric(Cl(vix_daily))
) %>%
  filter(!is.na(vix)) %>%
  filter(date >= start_date & date <= end_date) %>%
  arrange(date)

vix_weekly <- vix_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(vix = mean(vix)) %>%
  ungroup() %>%
  arrange(week) %>%
  mutate(
    vix_lag1 = lag(vix, 1)
  ) %>%
  filter(!is.na(vix_lag1)) %>%
  select(week, vix_lag1)

saveRDS(vix_weekly, "data_clean/vix_weekly.rds")

# TREASURY
treasury_daily <- getSymbols("^TNX", src = "yahoo", auto.assign = FALSE)

treasury_df <- data.frame(
  date = as.Date(index(treasury_daily)),
  treasury10yr = as.numeric(Cl(treasury_daily))
) %>%
  filter(!is.na(treasury10yr)) %>%
  filter(date >= start_date & date <= end_date) %>%
  arrange(date) %>%
  mutate(
    treasury10yr = treasury10yr / 10
  )

treasury_weekly <- treasury_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(treasury10yr = mean(treasury10yr)) %>%
  ungroup() %>%
  arrange(week) %>%
  mutate(
    treasury_lag1 = lag(treasury10yr, 1)
  ) %>%
  filter(!is.na(treasury_lag1)) %>%
  select(week, treasury_lag1)

saveRDS(treasury_weekly, "data_clean/treasury_weekly.rds")

# SP500
sp500_daily <- getSymbols("^GSPC", src = "yahoo", auto.assign = FALSE)

sp500_df <- data.frame(
  date = as.Date(index(sp500_daily)),
  sp500_price = as.numeric(Cl(sp500_daily))
) %>%
  filter(!is.na(sp500_price)) %>%
  filter(date >= start_date & date <= end_date) %>%
  arrange(date)

sp500_weekly <- sp500_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(sp500_price = mean(sp500_price)) %>%
  ungroup() %>%
  arrange(week) %>%
  mutate(
    sp500_return = log(sp500_price) - lag(log(sp500_price)),
    sp500_return_lag1 = lag(sp500_return, 1)
  ) %>%
  filter(!is.na(sp500_return_lag1)) %>%
  select(week, sp500_return_lag1)

saveRDS(sp500_weekly, "data_clean/sp500_weekly.rds")