# ==================================================
# Project:
# RBINS Cicadidae Collection Reorganisation
#
# Script: 02_explore_taxonomy.R
#
# Purpose:
# Explore and document the structure of the
# Species File taxonomy export.
#
# Prerequisite:
# Run 01_project_setup.R first.
#
# Output:
# None
#
# Author:
# Bart van Hoof
#
# Date:
# 2026-11-02
# ==================================================


# ==================================================
# Initial Structure Inspection
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
#
# Cicadidae Batsch, 1789
#
# Typical Hierarchy:
#
# Family
#   -> Subfamily
#     -> Tribe
#       -> Genus
#         -> Species
#           -> Subspecies
#
# Example:
#
# Cicadidae
#   -> Cicadettinae
#     -> Aragualnini
#       -> Aragualna
#         -> Aragualna plenalinea
#
# Taxonomic nodes contain:
#
# - otu_id
# - name
# - otu_clones
# - similar_otus
# - nomenclatural_synonyms
# - common_names
# - descendants
# - leaf_node
#
# Species File observations:
#
# - Species generally occur at leaf nodes.
# - Some fossil genera occur directly below Family.
# - Some taxa occur as uncertain placements,
#   e.g. [Cicada] acutipennis.
#
# ==================================================

# ==================================================
# Depth Analysis
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
      Taxon = node$name,
      Descendants = length(node$descendants),
      stringsAsFactors = FALSE
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
  
}

# Run analysis
analyse_depths(taxonomy)

# ==================================================
# Depth Analysis Findings
# ==================================================
#
# Typical depths:
#
# Depth 0 = Family
# Depth 1 = Subfamily
# Depth 2 = Tribe
# Depth 3 = Genus
# Depth 4 = Species
# Depth 5 = Species / Subspecies
# Depth 6 = Subspecies
#
# Important:
#
# Rank cannot always be inferred from depth alone.
#
# Exceptions include:
#
# - Fossil taxa
# - Uncertain generic placements
# - Historical taxa
#
# ==================================================

# ==================================================
# Taxon Name Structure Findings
# ==================================================
#
# Scientific name structure:
#
# 1 word  = genus or higher rank
# 2 words = species
# 3 words = subspecies
#
# Initial investigation identified two apparent
# four-word names.
#
# Subsequent validation showed these were caused by
# Unicode author names (e.g. Ōuchi) rather than
# scientific name structure.
#
# Parsing accuracy exceeded 99%.
#
# ==================================================

# ==================================================
# Nomenclatural Synonym Findings
# ==================================================
#
# Synonyms are stored in:
#
# node$nomenclatural_synonyms
#
# Synonyms occur at multiple taxonomic ranks:
#
# - Subfamily
# - Tribe
# - Genus
# - Species
#
# Exploration identified:
#
# - True synonyms
# - Misspellings [sic]
# - Historical combinations
# - Rank variants
# - Replacement names
# - Variety names
#
# Total synonym records discovered:
#
# 3070
#
# Dedicated synonym processing moved to:
#
# 04_build_synonym_master.R
#
# ==================================================

# ==================================================
# Historical Investigation Snippets
#
# Retained for reference only.
# ==================================================
#
# View(depth_analysis)
#
# subset(
#   depth_analysis,
#   Descendants == 0
# )
#
# Additional exploratory code moved to project
# milestones and production scripts.
#
# ==================================================