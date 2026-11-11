# ==================================================
# RBINS CICADIDAE COLLECTION REORGANISATION
#
# Script: 05_build_synonym_master.R
#
# Purpose:
# Transform raw synonym data into the final
# synonym worksheet structure.
#
# Input:
# synonym_master_raw.csv
#
# Output:
# synonym_master.csv
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-11
# ==================================================

# ==================================================
# Clean text - remove HTML tags
# ==================================================

clean_synonym_text <- function(text) {
  
  text <- gsub(
    "<i>|</i>",
    "",
    text
  )
  
  trimws(text)
  
}

synonym_master_raw$Synonym_Text <-
  sapply(
    synonym_master_raw$Synonym_Text,
    clean_synonym_text
  )

# ==================================================
# MILESTONE
#
# Raw synonym extraction completed.
#
# 3070 synonym records extracted from taxonomy.
#
# HTML formatting removed from synonym names.
#
# Next:
# - Extract Notes
# - Handle [sic]
# - Handle "non"
# - Handle varieties
# - Resolve encoding issues
#
# ==================================================