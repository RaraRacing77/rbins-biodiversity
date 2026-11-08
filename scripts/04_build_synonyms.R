# ==================================================
# RBINS CICADIDAE COLLECTION REORGANISATION
#
# Script: 04_build_synonym_master.R
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