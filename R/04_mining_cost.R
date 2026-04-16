dir.create("data_clean", showWarnings = FALSE)

start_date <- as.Date("2016-01-01") 
end_date   <- as.Date("2025-12-31")

energy_weekly <- readRDS("data_clean/energy_instruments.rds")

# Bitcoin Network Difficulty
difficulty_raw <- read.csv(
  "https://api.blockchain.info/charts/difficulty?timespan=all&format=csv",
  header = FALSE
)

names(difficulty_raw) <- c("date", "difficulty")

difficulty_df <- difficulty_raw %>%
  mutate(date = as.Date(date)) %>%
  filter(!is.na(difficulty)) %>%
  filter(date >= start_date & date <= end_date)

difficulty_weekly <- difficulty_df %>%
  mutate(week = floor_date(date, "week")) %>%
  group_by(week) %>%
  summarise(difficulty = mean(difficulty)) %>%
  ungroup() %>%
  arrange(week)

# Halving Cycle
difficulty_weekly <- difficulty_weekly %>%
  mutate(
    block_reward = case_when(
      week < as.Date("2012-11-28") ~ 50,
      week < as.Date("2016-07-09") ~ 25,
      week < as.Date("2020-05-11") ~ 12.5,
      week < as.Date("2024-04-20") ~ 6.25,
      TRUE ~ 3.125
    )
  )

mining_cost_df <- difficulty_weekly %>%
  inner_join(energy_weekly, by = "week") %>%
  mutate(
    energy_price = oil_price,
    mining_cost_proxy = difficulty * energy_price / block_reward,
    ln_mining_cost = log(mining_cost_proxy)
  ) %>%
  select(
    week,
    mining_cost_proxy,
    ln_mining_cost
  )

saveRDS(mining_cost_df, "data_clean/mining_cost_weekly.rds")