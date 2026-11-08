# ==================================================
# RBINS CICADIDAE COLLECTION REORGANISATION
#
# Script: 03_build_taxonomy_master.R
#
# Purpose:
# Build the taxonomic backbone from the Species File
# JSON export.
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-02
# ==================================================

# ==================================================
# Load Packages
# ==================================================

library(jsonlite)

# ==================================================
# Import Taxonomy
# ==================================================

taxonomy <- fromJSON(
  "data_raw/taxonomy_cicadidae.json",
  simplifyVector = FALSE
)

# ==================================================
# Create taxonomy_master Dataframe
# ==================================================

taxonomy_master <- data.frame(
  OTU_ID = integer(),
  Rank = character(),
  Parent_OTU_ID = integer(),
  Subfamily = character(),
  Tribe = character(),
  Genus = character(),
  Species = character(),
  Subspecies = character(),
  Accepted_Name = character(),
  Author = character(),
  Year = integer(),
  Authority = logical(),
  Status = character(),
  stringsAsFactors = FALSE
)

# ==================================================
# Now on to name cleaning functions.
#
# clean_taxon_name()
#
# Remove HTML formatting from taxon names.
# ==================================================

clean_taxon_name <- function(name) {
  
  gsub("<i>|</i>", "", name)
  
}

# ==================================================
# parse_fossil()
#
# Detect fossil taxa and remove fossil marker.
# ==================================================

parse_fossil <- function(name) {
  
  fossil <- grepl("^†\\s*", name)
  
  clean_name <- sub(
    "^†\\s*",
    "",
    name
  )
  
  list(
    fossil = fossil,
    clean_name = clean_name
  )
  
}

# ==================================================
# parse_taxon_name()
#
# Extract:
# - accepted name
# - genus
# - species
# - author
# - year
# NOT USED ANYMORE!!!
# ==================================================
# 
# parse_taxon_name <- function(name) {
#   
#   clean_name <- clean_taxon_name(name)
#   
#   year <- as.integer(
#     sub(".* ([0-9]{4})$", "\\1", clean_name)
#   )
#   
#   no_year <- sub(", [0-9]{4}$", "", clean_name)
#   
#   words <- strsplit(no_year, " ")[[1]]
#   
#   genus <- words[1]
#   
#   species <- words[2]
#   
#   author <- paste(
#     words[3:length(words)],
#     collapse = " "
#   )
#   
#   accepted_name <- paste(
#     genus,
#     species
#   )
#   
#   list(
#     accepted_name = accepted_name,
#     genus = genus,
#     species = species,
#     author = author,
#     year = year
#   )
#   
# }
# 
# ==================================================
# create_taxon_record()
#
# Create a taxonomy_master-compatible record.
#
# LEGACY FUNCTION
# NOT USED ANYMORE!!
# Replaced by direct record creation within
# build_taxonomy_master().
# ==================================================
# 
# create_taxon_record <- function(
#     otu_id,
#     rank,
#     parent_otu_id = NA,
#     subfamily = NA,
#     tribe = NA,
#     genus = NA,
#     species = NA,
#     accepted_name = NA,
#     author = NA,
#     year = NA,
#     status = "Accepted"
# ) {
#   
#   data.frame(
#     OTU_ID = otu_id,
#     Rank = rank,
#     Parent_OTU_ID = parent_otu_id,
#     Subfamily = subfamily,
#     Tribe = tribe,
#     Genus = genus,
#     Species = species,
#     Accepted_Name = accepted_name,
#     Author = author,
#     Year = year,
#     Status = status
#   )
#   
# }
# 
# ==================================================
# extract_taxon()
#
# Convert a taxonomic node into a dataframe row.
# LEGACY FUNCTION
# NOT USED ANYMORE
#
# Replaced by build_taxonomy_master().
# ==================================================
# 
# extract_taxon <- function(
#     node,
#     rank,
#     parent_otu_id = NA,
#     subfamily = NA,
#     tribe = NA,
#     genus = NA
# ) {
#   
#   parsed <- parse_taxon_name(node$name)
#   
#   data.frame(
#     OTU_ID = node$otu_id,
#     Rank = rank,
#     Parent_OTU_ID = parent_otu_id,
#     Subfamily = subfamily,
#     Tribe = tribe,
#     Genus = genus,
#     
#     Species = parsed$species,
#     Subspecies = parsed$subspecies,
#     Accepted_Name = parsed$accepted_name,
#     Author = parsed$author,
#     Year = parsed$year,
#     
#     Status = "Accepted"
#   )
# }
# 
# ==================================================
# Depth Analysis Functions
#
# EXPLORATORY CODE
# MOVED TO 02_explore_taxonomy.R
# ==================================================
# depth_analysis <- data.frame(
#   Depth = integer(),
#   Taxon = character(),
#   Descendants = integer(),
#   stringsAsFactors = FALSE
# )
# 
# analyse_depths()
# 
# ==================================================
# Build taxonomy_master
# 
# Taxonomy Processing Workflow
#
# clean_taxon_name()
#     ↓
# parse_fossil()
#     ↓
# extract_scientific_name()
#     ↓
# parse_scientific_name()
#     ↓
# parse_authority()
#     ↓
# determine_rank()
#     ↓
# build_taxonomy_master()
#
# ==================================================

build_taxonomy_master <- function(
    node,
    depth = 0,
    parent_otu_id = NA,
    subfamily = NA_character_,
    tribe = NA_character_
) {
  
  fossil_info <- parse_fossil(
    clean_taxon_name(node$name)
  )
  
  clean_name <- fossil_info$clean_name
  
  parsed <- parse_scientific_name(clean_name)
  
  authority <- parse_authority(clean_name)
  
  # ---- Determine rank ----
  
  if(depth == 0) {
    
    rank <- "family"
    
  } else if(depth == 1) {
    
    rank <- "subfamily"
    
    subfamily <- extract_scientific_name(clean_name)
    
  } else if(depth == 2) {
    
    rank <- "tribe"
    
    tribe <- extract_scientific_name(clean_name)
    
  } else if(!is.na(parsed$subspecies)) {
    
    rank <- "subspecies"
    
  } else if(!is.na(parsed$species)) {
    
    rank <- "species"
    
  } else {
    
    rank <- "genus"
    
  }
  
  # ---- Create record ----
  #1st determine if fossil or accepted
  status <- ifelse(
    fossil_info$fossil,
    "Fossil",
    "Accepted"
  )
  
  record <- data.frame(
    OTU_ID = node$otu_id,
    Rank = rank,
    Parent_OTU_ID = parent_otu_id,
    
    # Taxonomic lineage
    Subfamily = subfamily,
    Tribe = tribe,
    
    Genus = parsed$genus,
    Species = parsed$species,
    Subspecies = parsed$subspecies,
    
    Accepted_Name = extract_scientific_name(clean_name),
    
    Author = authority$author,
    Year = authority$year,
    Authority = authority$parenthesised,
    
    Status = status,
    
    stringsAsFactors = FALSE
  )
  
  taxonomy_master <<- rbind(
    taxonomy_master,
    record
  )
  
  # ---- Process descendants ----
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      build_taxonomy_master(
        child,
        depth = depth + 1,
        parent_otu_id = node$otu_id,
        subfamily = subfamily,
        tribe = tribe
      )
      
    }
    
  }
  
}

# ==================================================
# CURRENT FINDINGS
# ==================================================
# RANK DETERMINATION NOTES
#
# Family, Subfamily and Tribe are determined using
# upper hierarchy levels.
#
# Genus, Species and Subspecies are determined
# using parsed scientific names.
#
# Scientific name structure:
#
# 1 part -> Genus
# 2 parts -> Species
# 3 parts -> Subspecies
#
# ==================================================
# Scientific name extraction
# ==================================================

extract_scientific_name <- function(clean_name) {
  
  scientific_name <- stringr::str_remove(
    clean_name,
    "\\s+(\\(|[[:upper:]]).*,\\s*\\d{4}\\)?$"
  )
  
  trimws(scientific_name)
  
}

parse_scientific_name <- function(clean_name) {
  
  scientific_name <- extract_scientific_name(clean_name)
  
  parts <- strsplit(
    scientific_name,
    " "
  )[[1]]
  
  genus <- NA
  species <- NA
  subspecies <- NA
  
  if(length(parts) >= 1)
    genus <- parts[1]
  
  if(length(parts) >= 2)
    species <- parts[2]
  
  if(length(parts) >= 3)
    subspecies <- parts[3]
  
  list(
    genus = genus,
    species = species,
    subspecies = subspecies
  )
  
}

# depth_analysis$Scientific_Name <- sapply(
#   depth_analysis$Taxon,
#   extract_scientific_name
# )

determine_rank <- function(
    depth,
    parsed
) {
  
  if(depth == 0) return("family")
  
  if(depth == 1) return("subfamily")
  
  if(depth == 2) return("tribe")
  
  if(!is.na(parsed$subspecies))
    return("subspecies")
  
  if(!is.na(parsed$species))
    return("species")
  
  if(!is.na(parsed$genus))
    return("genus")
  
  return("unknown")
}

# ==================================================
# PARSING VALIDATION
#
# Initial validation identified two anomalous
# records caused by the author surname "Ōuchi".
#
# Scientific name extraction was subsequently
# updated to support Unicode uppercase characters.
#
# Parsing validation confirmed:
#
# - Genus extraction
# - Species extraction
# - Subspecies extraction
# - Authority extraction
#
# ==================================================
# parse_authority()
#
# Extract:
# - Author
# - Year
# Uses extract_scientific_name() to remove the
# scientific name before parsing authority text.
# ==================================================

parse_authority <- function(clean_name) {
  
  scientific_name <- extract_scientific_name(
    clean_name
  )
  
  authority_text <- sub(
    paste0("^", gsub(
      "([\\[\\]\\(\\)])",
      "\\\\\\1",
      scientific_name
    )),
    "",
    clean_name
  )
  
  authority_text <- trimws(authority_text)
  
  year_match <- regmatches(
    authority_text,
    regexpr("[0-9]{4}", authority_text)
  )
  
  year <- suppressWarnings(
    as.integer(year_match)
  )
  
  author <- gsub(
    ",?\\s*[0-9]{4}\\)?",
    "",
    authority_text
  )
  
  author <- gsub(
    "^\\(",
    "",
    author
  )
  
  author <- trimws(author)
  
  parenthesised <- grepl(
    "^\\(",
    authority_text
  )
  
  list(
    author = author,
    year = year,
    parenthesised = parenthesised
  )
  
}

# ==================================================
# DEVELOPMENT TESTS
#
# Historical testing code retained for reference.
# Commented out unless debugging.
#
# ==================================================
#
# family <- taxonomy
# subfamily <- ...
# species <- ...
#
# test_species <- extract_taxon(...)
#
# analyse_depths(taxonomy)
#
# View(depth_analysis)
#