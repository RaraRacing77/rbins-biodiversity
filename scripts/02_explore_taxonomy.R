# ==================================================
# Script: 02_explore_taxonomy.R
#
# Project:
# RBINS Cicadidae Collection Reorganisation
#
# Purpose:
# Investigate the structure of the Species File
# taxonomy export and document the hierarchical
# relationships between taxa.
#
# Prerequisite:
# Run 01_project_setup.R first to load required
# packages and import taxonomy_cicadidae.json.
#
# Outputs:
# None
#
# Findings:
# see below
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-02
# ==================================================

# First descendant of Cicadidae
taxonomy$descendants[[1]]

str(
  taxonomy$descendants[[1]],
  max.level = 2
)

# First descendant of Cicadettinae
str(
  taxonomy$descendants[[1]]$descendants[[1]],
  max.level = 2
)

# First descendant of Aragualnini
str(
  taxonomy$descendants[[1]]$descendants[[1]]$descendants[[1]],
  max.level = 2
)

# First descendant of Aragualna
str(
  taxonomy$descendants[[1]]$descendants[[1]]$descendants[[1]]$descendants[[1]],
  max.level = 2
)

# ==================================================
# JSON Structure Findings
# ==================================================
#
# Root:
# Cicadidae Batsch, 1789
#
# Hierarchy:
#
# Family
#   -> Subfamily
#     -> Tribe
#       -> Genus
#         -> Species
#
# Example:
#
# Cicadidae
#   -> Cicadettinae
#     -> Aragualnini
#      -> Aragualna
#       -> Aragualna plenalinea
#
# Notes:
#
# Taxonomic nodes contain:
# - otu_id
# - name
# - nomenclatural_synonyms
# - descendants
# - leaf_node
#
# Species are identified by:
#
# leaf_node = TRUE
#
# ==================================================
depth_analysis <- data.frame(
  Depth = integer(),
  Taxon = character(),
  Descendants = integer(),
  stringsAsFactors = FALSE
)

analyse_depths <- function(node, depth = 0) {
  
  depth_analysis <<- rbind(
    depth_analysis,
    data.frame(
      Depth = depth,
      Taxon = clean_taxon_name(node$name),
      Descendants = length(node$descendants)
    )
  )
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      analyse_depths(
        child,
        depth = depth + 1
      )
      
    }
  }
  
# ==================================================
# TAXON NAME STRUCTURE
#
# Analysis Results:
#
# 1 word  -> higher ranks / genus
# 2 words -> species
# 3 words -> subspecies
#
# Only 2 taxa with 4-word names were found and
# require individual investigation.
# ==================================================
 
parsed_results <- lapply(
  depth_analysis$Taxon,
  parse_scientific_name
)
  
depth_analysis$Genus <- sapply(
  parsed_results,
  function(x) x$genus
)
  
depth_analysis$Species <- sapply(
  parsed_results,
  function(x) x$species
)
  
depth_analysis$Subspecies <- sapply(
  parsed_results,
  function(x) x$subspecies
)
  
depth_analysis$Name_Words <- sapply(
  strsplit(
    depth_analysis$Scientific_Name,
    " "
  ),
  length
)

#
# problem_taxa <- subset(
#  depth_analysis,
#  Name_Words == 4
# )
#