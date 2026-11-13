# RBINS Biodiversity

Repository containing biodiversity data workflows, documentation,
and analyses developed in support of volunteer work with the Royal
Belgian Institute of Natural Sciences (RBINS).

## Current Projects

### Cicadidae Taxonomy Workflow

Development of a reproducible workflow to:

- import TaxonWorks JSON exports
- construct taxonomy tables
- extract nomenclatural authorship
- generate data workbooks
- support collection and biodiversity analyses

## Current Status

### Taxonomy Backbone

- 4,233 accepted taxa processed
- Scientific name parsing completed
- Authority extraction completed
- Parenthesised authority detection completed
- Subfamily and tribe lineage tracking implemented
- Fossil taxa identified and documented

### Synonym Processing

- Initial investigation completed
- 3,070 nomenclatural synonyms detected
- Dedicated synonym workflow planned

## Project Folder Structure

- `data_raw/`: Source data
- `data_processed/`: Processed datasets
- `scripts/`: R workflows
- `documentation/`: Project documentation
- `output/`: Generated outputs

## Outputs

Current outputs include:

- `taxonomy_master.csv`
- Taxonomic hierarchy tables
- Authority metadata
- Validation reports

Future outputs:

- `synonym_master.csv`
- Darwin Core-compatible export tables

## Tools

- R
- RStudio
- Git & GitHub
- TaxonWorks
- tidyverse
- biodiversity information standards: Taxonomic workflows are designed with
Darwin Core interoperability in mind, enabling future export and integration
with GBIF and other biodiversity data infrastructures.

## Related Projects

## Related Projects

- [Searching for Cullum's Bee](https://searchingforcullumanus.com/)
- Cullumanus GitHub repository
