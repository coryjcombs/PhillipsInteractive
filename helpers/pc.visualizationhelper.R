# Phillips Curve Analysis     #
# Conducted for FI Consulting #
# August 26, 2019             #


#### Packages and Seed ####

library(tidyverse) # Includes dplyr, tidyr, readr, tibble, ggplot2
library(ggpubr) # For further ggplot customization
library(lubridate) # For time series data management
library(zoo) # "Z's orderded observations" package for time series
library(reshape2) # For melt function
library(stargazer) # For multi-format regression table outputs
library(plotly) # For adding interactivity to plots
source("helpers/pc.datahelper.R") # Custom functions for Phillips curve analysis

set.seed(42) # Ensures reproducibility given random elements


#### Settings ####

# Specify locations of datasets to be imported
case_study_data <- "data/Case_Study_Data.csv" # Data provided by FI Consulting
fred_clf_data <- "data/FRED_clf.csv" # Data obtained from FRED at https://fred.stlouisfed.org/series/CLF16OV; CSV formatted to separate date values
fred_nrou_data <- "data/FRED_nrou.csv" # Data obtained from FRED at https://fred.stlouisfed.org/series/CLF16OV; CSV formatted to separate date values
bls_u6_data <- "data/BLS_U6.csv" # Data obtained from BLS at https://data.bls.gov/timeseries/LNS13327709

# SELECT choice of quarterly or monthly resolution for U3 analysis
grain <- "monthly" # Incorporates FRED labor force data to supplement FI Consulting data
#grain <- "quarterly" # Includes only FI Consulting data

# Specify directory into which regression tables should be saved
reg_dir <- "./regression/" # Regression subfolder
# Specify document type for regression table export
reg_doctype <- "html"

# Set graph color palette
custom_palette = c("#007ab3", "#69c7b1", "#c4a664")


#### Data Preparation ####

# Import data in tidy tibble format
pc_raw <- read_csv(case_study_data)
fred_nrou <- read_csv(fred_nrou_data)
bls_u6 <- read_csv(bls_u6_data)

# Conduct basic overview of raw data
summary(pc_raw) # Basic overview of dataset
sum(is.na(pc_raw)) # Confirming no NA values found
unique(pc_raw$Data) # Note the "CPI" and "Consumer Price Index" disaggregation, to be fixed during preparation

# Create clean phillips curve tibble containing inflation and unemployment (U3) time series data
pc <- prepare.pc.data(data = pc_raw)


#### Part 1: Exploratory Data Analysis ####

# AIM: Explore data for sake of further hypothesis formation. The base hypothesis is that the curve holds
#  for the United States today.
# RESULTS: Exploration shows substantial variation between time periods, both within and across decades. New
#  hypotheses include I) the link faces a confounding variable frequently present (note that most periods
#  did not see a "very rapid rise in import prices," which Phillips argued would inhibit the relationship),
#  and II) there is relationship between similar but distinct variables, which can, but do not in general, align
#  with a high correlation between inflation and unemployment. Modern economic theory suggests expected inflation
#  and natural rate of unemployment as candidates. Each of these will be analyzed. Finally, another option
#  could be U6 unemployment rates, which include discouraged workers and other parts of the population excluded
#  from the base U3 data. U6 data will also be analyzed.

# All exploratory analysis moved into app.R for reactive display


#### Part 2: Phillips Curve Analysis with U3 Unemployment Rate ####

# AIM: Assess the hypothesis that the Phillips curve holds, i.e. that there is a negative, nonlinear
#  relationship between inflation and unemployment in the United States.
# RESULT: Statistical and visual analysis of the full range of periods between 1949 and 2017, for which
#  data are available, demonstrate immense variation, with no consistent pattern of the curve enduring.
#  The evidence suggests the basic formulation of Phillips' theory does not hold for the U.S. today.

# Construct linear models for the specified periods
pc_model_linear_50s <- pc.model.linear(data = pc, period_start = 1950, period_end = 1959)
pc_model_linear_60s <- pc.model.linear(data = pc, period_start = 1960, period_end = 1969)
pc_model_linear_70s <- pc.model.linear(data = pc, period_start = 1970, period_end = 1979)
pc_model_linear_80s <- pc.model.linear(data = pc, period_start = 1980, period_end = 1989)
pc_model_linear_90s <- pc.model.linear(data = pc, period_start = 1990, period_end = 1999)
pc_model_linear_00s <- pc.model.linear(data = pc, period_start = 2000, period_end = 2009)
pc_model_linear_10s <- pc.model.linear(data = pc, period_start = 2010, period_end = 2017)
pc_model_linear_full <- pc.model.linear(data = pc, period_start = 1949, period_end = 2017)

# Construct nonlinear models for the specified periods with formula: inflation ~ u3 + I(u3^2)
pc_model_nonlinear_50s <- pc.model.nonlinear(data = pc, period_start = 1950, period_end = 1959)
pc_model_nonlinear_60s <- pc.model.nonlinear(data = pc, period_start = 1960, period_end = 1969)
pc_model_nonlinear_70s <- pc.model.nonlinear(data = pc, period_start = 1970, period_end = 1979)
pc_model_nonlinear_80s <- pc.model.nonlinear(data = pc, period_start = 1980, period_end = 1989)
pc_model_nonlinear_90s <- pc.model.nonlinear(data = pc, period_start = 1990, period_end = 1999)
pc_model_nonlinear_00s <- pc.model.nonlinear(data = pc, period_start = 2000, period_end = 2009)
pc_model_nonlinear_10s <- pc.model.nonlinear(data = pc, period_start = 2010, period_end = 2017)
pc_model_nonlinear_full <- pc.model.nonlinear(data = pc, period_start = 1949, period_end = 2017)


#### Part 3: Expected Inflation and Natural Rate of Unemployment ####

# AIM: Assess the hypotheses that the Phillips curve holds for the United States when considering either
#  the natural rate of unemployment, expected inflation, or both.
# RESULT: Statistical and visual analysis of the full range of periods between 1949 and 2017 display
#  similar results to the previous phase of analysis. The evidence suggests this updated formulation
#  of Phillips' theory also does not hold for the U.S. today.

# Prepare natural unemployment rate data
fred_nrou_clean <- prepare.nrou.data(data = fred_nrou)

# Join natural unemployment rate data with base phillips curve data
pc_nrou <- join.nrou.data(left = pc, right = fred_nrou_clean)

## Expected Inflation Scenarios

# Expected Inflation Scenario plots moved into app.R for reactive display


#### Part 4: U6 Unemployment Rate ####
# AIM: Assess the hypotheses that the Phillips curve holds for the United States when considering the
#  U6 unemployment rate.
# RESULT: As before, statistical and visual analysis of the full range of periods between 1949 and 2017
#  display similar results to the previous phases of analysis. In particular, while the difference between
#  U3 and U6 data is highly important in some areas due to differences of magnitude, they reamin highly
#  correlated, resulting in a similar (lack of) relation to unemployment. The evidence suggests this
#  additional updated formulation of Phillips' theory also does not hold for the U.S. today.

# Prepare U6 unemployment rate data
bls_u6_clean <- prepare.u6.data(data = bls_u6)

# Join U6 unemployment rate data with base phillips curve data
pc_u6 <- join.u6.data(left = pc, right = bls_u6_clean)

# Unemployment plots moved into app.R for reactive display

# Measure and confirm the high and statistically significant correlation between U3 and U6
unemp_linear_reg <- lm(pc_u6$u3 ~ pc_u6$u6) # Demonstrates high statistical closeness of the datasets
#summary(unemp_linear_reg)


#### Supplement: Interactive Graphs ####

# Optional interactive visualizations for quick reference to point values during analysis
# Users may wrap any existing plot in "ggplotly(...)"

# plotly_infl_exp_nrou_60s <- ggplotly(plot_infl_exp_nrou_60s)
# plotly_infl_exp_nrou_60s

# plotly_infl_exp_nrou_80s <- ggplotly(plot_infl_exp_nrou_80s)
# plotly_infl_exp_nrou_80s

### End of File ###