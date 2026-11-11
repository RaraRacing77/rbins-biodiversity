# ==================================================
# RBINS CICADIDAE COLLECTION REORGANISATION
#
# Script: 04_build_synonym_master.R
# Output: synonym_master_raw.csv
#
# Purpose:
# Build nomenclatural synonym tables from the
# Species File JSON export.
#
# Status:
# Design phase.
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-08
# ==================================================

find_synonyms <- function(node) {
  
  if(length(node$nomenclatural_synonyms) > 0) {
    
    cat(
      clean_taxon_name(node$name),
      "\n"
    )
    
  }
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      find_synonyms(child)
      
    }
    
  }
  
}

str(taxonomy, max.level = 4)

count_synonyms <- function(node) {
  
  n <- length(node$nomenclatural_synonyms)
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      n <- n + count_synonyms(child)
      
    }
    
  }
  
  n
  
}

find_synonym_examples <- function(node) {
  
  if(length(node$nomenclatural_synonyms) > 0) {
    
    cat("\n")
    cat("Accepted:", clean_taxon_name(node$name), "\n")
    print(node$nomenclatural_synonyms)
    
    return()
    
  }
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      find_synonym_examples(child)
      
    }
    
  }
  
}

# ==================================================
# Create Synonym Master (Raw)
# ==================================================

synonym_master_raw <- data.frame(
  Accepted_OTU_ID = integer(),
  Accepted_Name = character(),
  Synonym_Text = character(),
  stringsAsFactors = FALSE
)

# ==================================================
# extract_synonyms()
#
# Extract all nomenclatural synonyms exactly as
# stored in the Species File.
# ==================================================

extract_synonyms <- function(node) {
  
  if(length(node$nomenclatural_synonyms) > 0) {
    
    for(synonym in node$nomenclatural_synonyms) {
      
      synonym_master_raw <<- rbind(
        synonym_master_raw,
        data.frame(
          Accepted_OTU_ID = node$otu_id,
          Accepted_Name = clean_taxon_name(node$name),
          Synonym_Text = synonym,
          stringsAsFactors = FALSE
        )
      )
      
    }
    
  }
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      extract_synonyms(child)
      
    }
    
  }
  
}

# ==================================================
# Export synonym_master_raw.csv
# ==================================================

write.csv(
  synonym_master_raw,
  "data_processed/synonym_master_raw.csv",
  row.names = FALSE
)