# Project Log

## 2026-10-30

Downloaded Cicadidae taxonomy from Species File.

## 2026-11-02

Completed initial project setup.

Created:

- Workbook structure
- R Project library
- README documentation
- Workflow documentation
- Data dictionary
- Curator notes

Installed required R packages:

- jsonlite
- dplyr
- purrr
- stringr
- tidyr
- openxlsx

### Next step

Investigate JSON structure and determine extraction strategy for taxonomy_master and synonyms. Test import of taxonomy_cicadidae.json.

Successfully imported taxonomy_cicadidae.json.

Top-level taxon:

Cicadidae Batsch, 1789

JSON structure contains:

otu_id name nomenclatural_synonyms descendants leaf_node. The taxonomy is stored as a hierarchical tree structure.

### Next step

Investigate descendant nodes and identify taxonomic hierarchy levels.

Investigated Species File JSON structure.

Hierarchy confirmed:

Family → Subfamily → Tribe → Genus → Species

Species are identified using:

leaf_node = TRUE

Each taxonomic node contains:

- otu_id
- name
- nomenclatural_synonyms
- descendants
- leaf_node

Parent-child relationships are maintained through the descendants field.

### Next step

Create a recursive function to traverse the hierarchy and extract taxa into taxonomy_master.

Successfully imported Species File JSON.

Investigated taxonomic hierarchy.

Confirmed hierarchy:

Family
  → Subfamily
    → Tribe
      → Genus
        → Species

Created prototype taxonomy_master record:

Aragualna plenalinea
OTU_ID 5978

Confirmed extraction of:

- OTU_ID
- Parent_OTU_ID
- Rank
- Taxonomic hierarchy
- Author
- Year

### Next step

Design recursive function to traverse all taxa
and populate taxonomy_master automatically.

Successfully created first taxonomy_master records.

Records created:

- Cicadidae (family)
- Aragualna plenalinea (species)

Confirmed ability to:

- Extract OTU_ID
- Extract hierarchy
- Create taxonomy records
- Append records to taxonomy_master

### Next step

Create a recursive traversal function to automatically
extract all taxa from the Species File hierarchy.

Phase 3 Progress

Created taxonomy_master dataframe structure.

Successfully generated prototype records for:

Family
Species
Successfully appended records to taxonomy_master.

Validated field structure:

OTU_ID
Rank
Parent_OTU_ID
Subfamily
Tribe
Genus
Species
Accepted_Name
Author
Year
Status
Next task: Create extract_taxon() function.

Successfully implemented:

- clean_taxon_name()
- parse_taxon_name()
- create_taxon_record()
- extract_taxon()

Taxonomic records can now be generated automatically.

Verified extraction of:

- OTU_ID
- Parent_OTU_ID
- Rank
- Subfamily
- Tribe
- Genus
- Species
- Accepted_Name
- Author
- Year
- Status

### Next step

Develop recursive traversal function to walk the
entire Cicadidae taxonomy tree.

Current milestone:

Taxonomic records can now be extracted automatically.

Next objective:

Develop traverse_taxonomy() function to recursively walk the Species File hierarchy and visit all taxa.

Major milestone achieved.

Successfully implemented recursive traversal of the Species File taxonomy tree.

The function can now visit all taxa within the Cicadidae hierarchy from family level to species level.

Next task:

Generate taxonomy_master records automatically during tree traversal.

Important Finding

Tree traversal works correctly.

Taxonomic hierarchy is not uniform across all branches.

Depth values provide useful context but do not always correspond directly to taxonomic rank.

Future work is required to determine rank assignment logic.

Conducted taxonomy hierarchy analysis using recursive
traversal of the Species File JSON export.

Key findings:

- Family = depth 0
- Subfamily = depth 1
- Tribe = depth 2
- Genus predominantly occurs at depth 3
- Species and subspecies occur at multiple depths

Conclusion:

Taxonomic rank cannot be reliably inferred from tree
depth alone.

Implemented scientific name parsing:

- clean_taxon_name()
- extract_scientific_name()
- parse_scientific_name()

Scientific name parsing successfully separates:

- Genus
- Species
- Subspecies

Validation results:

1-word scientific names: 656
2-word scientific names: 3440
3-word scientific names: 135
4-word scientific names: 2

The two 4-word cases were caused by the author name
"Ōuchi" being incorrectly identified as part of the
scientific name.

Parsing accuracy considered acceptable (>99%).

Decision:

Future rank determination will be based on parsed
scientific names rather than hierarchy depth.

### Next step

Integrate parsing, rank determination and recursive
traversal to automatically populate taxonomy_master.

Known Issues

A small number of taxa enclosed in square brackets
(e.g. [Cicada] acutipennis) are currently assigned an
incorrect rank.

The issue affects a very small number of records and
can be corrected manually in the final workbook.

The underlying taxon names and OTU identifiers remain
correct.

Authority parsing currently extracts:

- Author
- Year

Parentheses indicating changed generic combination
are not currently preserved.

Potential future enhancement:
Store complete authority string separately.

Current Status

Successfully generated a complete taxonomy backbone
containing 4,233 taxa from the Species File JSON export.

Recursive traversal, scientific-name parsing,
authority parsing and hierarchy processing are
operational.

The exported CSV requires further validation before
being adopted as the final taxonomy master file.

Next session:

- Review CSV structure
- Validate rank assignments
- Validate lineage fields
- Refine export model