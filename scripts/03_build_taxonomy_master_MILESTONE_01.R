# --------------------------------------------------
# Script: 03_build_taxonomy_master.R
#
# Project:
# RBINS Cicadidae Collection Reorganisation
#
# Purpose:
# Traverse the Species File taxonomy hierarchy and
# extract taxonomic records for population of the
# taxonomy_master worksheet.
#
# Inputs:
# data_raw/taxonomy_cicadidae.json
#
# Outputs:
# Taxonomy data frame
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-02
# --------------------------------------------------

library(jsonlite)

taxonomy <- fromJSON(
  "data_raw/taxonomy_cicadidae.json",
  simplifyVector = FALSE
)

# Example hierarchy

# Family
family <- taxonomy

# Subfamily
subfamily <- taxonomy$descendants[[1]]

# Tribe
tribe <- subfamily$descendants[[1]]

# Genus
genus <- tribe$descendants[[1]]

# Species
species <- genus$descendants[[1]]


# Test
test_taxon <- data.frame(
  OTU_ID = taxonomy$otu_id,
  Name = taxonomy$name
)

test_taxon

# Create an empty table/dataframe
taxonomy_master <- data.frame(
  OTU_ID = integer(),
  Rank = character(),
  Parent_OTU_ID = integer(),
  Subfamily = character(),
  Tribe = character(),
  Genus = character(),
  Species = character(),
  Accepted_Name = character(),
  Author = character(),
  Year = integer(),
  Status = character()
)

# --------------------------------------------------
# Test hierarchy extraction
# --------------------------------------------------

family <- taxonomy
subfamily <- taxonomy$descendants[[1]]
tribe <- subfamily$descendants[[1]]
genus <- tribe$descendants[[1]]
species <- genus$descendants[[1]]

family$name
subfamily$name
tribe$name
genus$name
species$name

# --------------------------------------------------
# Test HTML tag removal
# --------------------------------------------------

clean_name <- gsub("<i>|</i>", "", species$name)

# prototype_record <- data.frame(
#  OTU_ID = species$otu_id,
#  Rank = "species",
#  Parent_OTU_ID = genus$otu_id,
#  Subfamily = "Cicadettinae",
#  Tribe = "Aragualnini",
#  Genus = "Aragualna",
#  Species = "plenalinea",
#  Accepted_Name = "Aragualna plenalinea",
#  Author = "Champanhet, Boulard & Gaiani",
#  Year = 2000,
#  Status = "Accepted"
# )
#
#prototype_record
#
# --------------------------------------------------
# Proof of concept
#
# Create individual taxonomic records and append
# them to taxonomy_master.
#
# This validates the structure prior to building
# the automated traversal function.
# --------------------------------------------------
#
# family_record <- data.frame(
#  OTU_ID = family$otu_id,
#  Rank = "family",
#  Parent_OTU_ID = NA,
#  Subfamily = NA,
#  Tribe = NA,
#  Genus = NA,
#  Species = NA,
# Accepted_Name = "Cicadidae",
#  Author = "Batsch",
#  Year = 1789,
#  Status = "Accepted"
# )
#
# family_record

taxonomy_master <- rbind(
  taxonomy_master,
  family_record
)

taxonomy_master

taxonomy_master <- rbind(
  taxonomy_master,
  prototype_record
)

taxonomy_master

# --------------------------------------------------
# Prepare for recursive extraction
# --------------------------------------------------

clean_taxon_name <- function(name) {
  
  clean_name <- gsub("<i>|</i>", "", name)
  
  return(clean_name)
  
}

clean_taxon_name(species$name)

extract_basic_info <- function(node) {
  
  data.frame(
    OTU_ID = node$otu_id,
    Full_Name = clean_taxon_name(node$name)
  )
  
}

extract_basic_info(species)

# ==================================================
# Test extraction
# ==================================================

family <- taxonomy

subfamily <- taxonomy$descendants[[1]]

tribe <- subfamily$descendants[[1]]

genus <- tribe$descendants[[1]]

species <- genus$descendants[[1]]

# ==================================================
# Taxon record function
# ==================================================

create_taxon_record <- function(
    otu_id,
    rank,
    parent_otu_id = NA,
    subfamily = NA,
    tribe = NA,
    genus = NA,
    species = NA,
    accepted_name = NA,
    author = NA,
    year = NA,
    status = "Accepted"
) {
  
  data.frame(
    OTU_ID = otu_id,
    Rank = rank,
    Parent_OTU_ID = parent_otu_id,
    Subfamily = subfamily,
    Tribe = tribe,
    Genus = genus,
    Species = species,
    Accepted_Name = accepted_name,
    Author = author,
    Year = year,
    Status = status
  )
  
}

# family_record <- create_taxon_record(
#  otu_id = 5974,
#  rank = "family",
#  accepted_name = "Cicadidae",
#  author = "Batsch",
#  year = 1789
# )
# ==================================================
# Parse taxon name
# ==================================================

parse_taxon_name <- function(name) {
  
  clean_name <- clean_taxon_name(name)
  
  year <- as.integer(
    sub(".* ([0-9]{4})$", "\\1", clean_name)
  )
  
  no_year <- sub(", [0-9]{4}$", "", clean_name)
  
  words <- strsplit(no_year, " ")[[1]]
  
  genus <- words[1]
  
  species <- words[2]
  
  author <- paste(
    words[3:length(words)],
    collapse = " "
  )
  
  accepted_name <- paste(
    genus,
    species
  )
  
  list(
    accepted_name = accepted_name,
    genus = genus,
    species = species,
    author = author,
    year = year
  )
  
}

parse_taxon_name(species$name)

year <- as.integer(
  sub(".* ([0-9]{4})$", "\\1", clean_name)
)

parse_taxon_name(genus$name)

# ==================================================
# extract_taxon()
#
# Purpose:
# Convert a single taxonomic node into a row
# compatible with taxonomy_master.
#
# Inputs:
# - node
# - rank
# - parent_otu_id
# - subfamily
# - tribe
# - genus
#
# Returns:
# Single-row dataframe
# ==================================================

extract_taxon <- function(
    node,
    rank,
    parent_otu_id = NA,
    subfamily = NA,
    tribe = NA,
    genus = NA
) {
  
  parsed <- parse_taxon_name(node$name)
  
  data.frame(
    OTU_ID = node$otu_id,
    Rank = rank,
    Parent_OTU_ID = parent_otu_id,
    Subfamily = subfamily,
    Tribe = tribe,
    Genus = genus,
    
    Species = parsed$species,
    Accepted_Name = parsed$accepted_name,
    Author = parsed$author,
    Year = parsed$year,
    
    Status = "Accepted"
  )
}

extract_taxon(species, "species")

extract_taxon(
  species,
  "species",
  parent_otu_id = genus$otu_id,
  subfamily = "Cicadettinae",
  tribe = "Aragualnini",
  genus = "Aragualna"
)

# ==================================================
# Milestone
#
# Successfully created automated taxon extraction.
#
# Function accepts:
# - taxonomic node
# - rank
# - hierarchy information
#
# Function returns:
# - taxonomy_master-compatible row
#
# Next step:
# Extract Genus, Species and Author automatically.
#
# ==================================================
# ==================================================
# Development Test
#
# Verify that extract_taxon() creates a valid
# taxonomy_master record.
# ==================================================

# test_species <- extract_taxon(
#     species,
#     "species",
#     parent_otu_id = genus$otu_id,
#     subfamily = "Cicadettinae",
#     tribe = "Aragualnini",
#     genus = "Aragualna"
# )
#
# test_species
#
# taxonomy_master <- rbind(
#     taxonomy_master,
#     test_species
# )

# ==================================================
# Traverse taxonomy tree
# ==================================================

traverse_taxonomy <- function(
    node,
    rank,
    parent_otu_id = NA,
    subfamily = NA,
    tribe = NA,
    genus = NA
) {
  
  cat(
    clean_taxon_name(node$name),
    "\n"
  )
  
  if(length(node$descendants) > 0) {
    
    for(child in node$descendants) {
      
      traverse_taxonomy(
        child,
        rank = "unknown"
      )
      
    }
      
  }
    
}

# ==================================================
# RECURSION TEST
#
# Goal:
# Verify that traverse_taxonomy() can walk
# the entire Cicadidae hierarchy.
#
# Expected result:
#
# Family
# → Subfamily
# → Tribe
# → Genus
# → Species
#
# No records are created yet.traverse_taxonomy()
#
# ==================================================






# ==================================================
# Development Tests
# ==================================================
