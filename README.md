# Bitcoin IV Project

This project studies the causal effect of Bitcoin mining costs on Bitcoin prices using an instrumental variables approach.

## Files
- `R/01_download_data.R`: downloads raw data
- `R/05_merge.R`: constructs the final analysis dataset
- `R/06_regression.R`: runs OLS, first-stage, and IV regressions
- `data_raw/`: raw source data
- `data_clean/`: cleaned datasets
- `final_paper.pdf`: final submitted paper

## Replication
Run the scripts in this order:

1. `R/01_download_data.R`
2. `R/05_merge.R`
3. `R/06_regression.R`

## Main question
Does the cost of mining Bitcoin have a causal effect on Bitcoin prices?

## Method
2SLS / instrumental variables with lagged oil prices as instruments for mining cost.
