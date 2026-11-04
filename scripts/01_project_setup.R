# --------------------------------------------------
# Project:
# RBINS Cicadidae Collection Reorganisation
#
# Institution:
# Royal Belgian Institute of Natural Sciences
#
# Author:
# Bart van Hoof
#
# Purpose:
# Create a taxonomic backbone for the Cicadidae
# collection based on Species File taxonomy.
#
# Date:
# 2026-11-02
# --------------------------------------------------
# Required packages
# --------------------------------------------------

# Install once if required:
# install.packages(c(
#   "jsonlite",
#   "dplyr",
#   "purrr",
#   "stringr",
#   "openxlsx",
#   "tidyr"
# ))

# Load packages
library(jsonlite)
library(dplyr)
library(purrr)
library(stringr)
library(openxlsx)
library(tidyr)
library(jsonlite)

taxonomy <- fromJSON(
  "data_raw/taxonomy_cicadidae.json",
  simplifyVector = FALSE
)

names(taxonomy)

str(taxonomy, max.level = 2)