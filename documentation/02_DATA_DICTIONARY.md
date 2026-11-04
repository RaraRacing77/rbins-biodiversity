# Cicadidae Collection Database

## Data Dictionary

Version: 0.1

Date: 2026-11-02

Purpose: This document defines the structure, fields, and usage rules of the RBINS Cicadidae Collection Organisation Database.

## Taxonomic Authority

Primary Source: Species File Project

Taxonomic Scope: Family Cicadidae (worldwide)

Website: <https://hoppers.speciesfile.org/otus/5974/overview>

Local Export: taxonomy_cicadidae.json

Purpose: To provide the accepted taxonomic backbone for the RBINS Cicadidae collection.

Notes: The taxonomy may evolve over time. Updates should be documented in the change_log worksheet.

Where discrepancies occur between specimen labels and accepted taxonomy, the accepted taxonomy shall be retained in taxonomy_master and historical names shall be recorded in the synonyms table.

JSON Structure Notes

The Species File export is organised as a recursive
hierarchical tree.

Each taxonomic node contains:

- otu_id
- name
- otu_clones
- similar_otus
- nomenclatural_synonyms
- common_names
- descendants
- leaf_node

Child taxa are stored within the descendants field.

# taxonomy_master

Purpose: Authoritative list of accepted Cicadidae taxa.

Only accepted taxa should be stored in this table.

Taxonomic Citation Accepted_Name, Author, and Year together form the complete taxonomic citation for a taxon.

Example:

Cryptotympana atrata (Fabricius, 1775)

These fields should be retained whenever available from the adopted authority source.

## OTU_ID

Unique identifier from Species File.

Type: Integer

Example: 5974

## Parent_OTU_ID

Identifier of the parent taxon.

## Rank

Taxonomic rank assigned to the taxon.

Type: Text

Allowed Values:

- family
- subfamily
- tribe
- genus
- species
- subspecies

## Status

Taxonomic status of the record.

Type: Text

Planned Values:

- Accepted
- Fossil
- Uncertain

Default: Accepted

## Accepted_Name

Complete current scientific name.

Type: Text

Examples:

Cryptotympana atrata

Magicicada septendecim

## Author

Taxonomic authority responsible for the original description of the taxon.

Type: Text

Example: Linnaeus

Notes:

- Author names should follow the format provided by the adopted taxonomic authority source.
- Author names should not be abbreviated unless the source taxonomy uses an abbreviation.
- Parentheses around author names may indicate that the taxon has been transferred from its original genus.

Example:

Magicicada septendecim (Linnaeus)

indicates that Linnaeus originally described the species under a different genus.

## Year

Year of publication of the original taxonomic description.

Type: Integer

Example: 1758

Notes:

- Year should correspond to the original valid publication associated with the taxon.
- When available, the year should be obtained directly from the adopted taxonomic authority source.
- Missing values should be left blank rather than estimated.

Importance:

The combination of Author and Year assists in distinguishing between taxa with similar names and provides traceability to the original scientific description.

### Table Rules

1.  Only accepted taxa shall be stored in taxonomy_master.
2.  Taxonomic synonyms shall be stored in the synonyms table.
3.  OTU_ID values should not be modified manually.
4.  Parent_OTU_ID should reference an existing taxon.
5.  Taxonomic changes should be documented in change_log.

# synonyms

Purpose: Records nomenclatural synonyms, historical names, misspellings, and alternative taxonomic combinations associated with accepted Cicadidae taxa.

Current Status: Not yet populated.

Future Population: To be generated from the Species File taxonomy export and updated as taxonomic revisions are incorporated.

Business Rules:

- Accepted taxa should not be stored in this table unless acting as the target accepted name.
- Each synonym should reference a valid Accepted_Name and OTU_ID.
- Historical names appearing on specimen labels should be recorded here rather than added to taxonomy_master.
- Synonyms should be linked to the currently accepted taxon whenever possible.

# collection_layout

Purpose: Documents the physical arrangement of specimens within drawers, cabinets, or storage units.

Current Status: Not yet populated.

Future Population: To be completed during physical collection review at RBINS in consultation with the collection curator.

Business Rules:

- Drawer identifiers should be unique.
- Taxa should be arranged according to the accepted taxonomy maintained in taxonomy_master.
- Changes to drawer organisation should be recorded in change_log.
- Notes should be used to document special storage requirements, mixed drawers, or temporary arrangements.

Potential Uses:

- Collection reorganisation.
- Location tracking.
- Specimen retrieval.
- Future digitisation projects.

# collection_inventory

Purpose: Records specimen holdings associated with the Cicadidae collection.

Current Status: Not yet populated.

Future Population: To be carried out during collection review at RBINS.

Business Rules:

- Each record should reference an OTU_ID whenever possible.
- Taxonomic names should match taxonomy_master.
- Specimen counts should reflect currently verified holdings.
- Identification uncertainties should be documented in Notes and, where appropriate, in taxonomic_issues.
- Verification status should indicate whether the taxonomic identification has been reviewed.

Potential Uses:

- Collection auditing.
- Digitisation.
- Taxonomic revision work.
- Research support.
- Collection statistics.Purpose: Records specimen holdings.

### Potential Future Development

The following fields may be considered in future versions:

- Subtribe
- Catalogue Number
- Barcode
- Type Status
- Determiner
- Determination Date
- Country
- Region
- Collection Event
- Specimen Identifier

# new_accessions

Purpose: Tracks newly acquired specimens that have not yet been fully integrated into the main Cicadidae collection.

Current Status: Not yet populated.

Future Population: To be populated as new material is received, identified, and prepared for incorporation into the collection.

Business Rules:

- Each accession should receive a Temporary_ID.
- Taxonomic names should be checked against taxonomy_master before integration.
- Identification uncertainties should be recorded in Notes.
- Once incorporated into the collection, the Integrated field should be updated.

Potential Uses:

- Accession tracking.
- Collection growth monitoring.
- Identification workflows.
- Digitisation planning.

### Fields

Temporary_ID

: Temporary accession identifier.

Genus

: Assigned genus.

Species

: Assigned species.

Source

: Donor, institution, expedition, or acquisition source.

Collector

: Person responsible for collecting the material.

Integrated

: Indicates whether the material has been incorporated into the collection.

Notes

: Additional comments or observations.

# taxonomic_issues

Purpose: Records unresolved nomenclatural, identification, classification, or data-quality issues requiring review.

Current Status: Not yet populated.

Future Population: To be populated whenever taxonomic conflicts or uncertainties are identified.

Business Rules:

- Each issue should receive a unique Issue_ID.
- Issues should remain open until reviewed by the curator or an appropriate specialist.
- Resolution actions should be documented in Notes.
- Major taxonomic changes resulting from issue resolution should be recorded in change_log.

Status Values:

- Open
- Under Review
- Resolved

Potential Uses:

- Taxonomic review.
- Data-quality management.
- Collection audits.
- Curatorial decision tracking.

# change_log

Purpose: Provides an audit trail of significant modifications made to the workbook, taxonomy, collection layout, or inventory.

Current Status: Ready for use.

Business Rules:

- Significant changes should be documented as they occur.
- Entries should contain a date, description, and relevant notes.
- Changes affecting taxonomy should reference the source supporting the change where possible.
- Structural modifications to the workbook should be documented.

Potential Uses:

- Change tracking.
- Audit support.
- Project documentation.
- Knowledge transfer.

### Fields

Date

: Date of modification.

Action

: Description of change.

Drawer

: Affected drawer, if applicable.

Notes

: Supporting information.

# collectors_reference

Purpose: Provides reference information on collectors represented within the Cicadidae collection.

Current Status: Not yet populated.

Future Population: To be populated during collection review and specimen data capture.

Business Rules:

- Collector names should be recorded consistently.
- Alternative spellings should be documented in Notes.
- Biographical information should be factual and sourced where possible.

Potential Uses:

- Historical research.
- Collection provenance.
- Digitisation support.
- Label interpretation.

### Fields

Collector

: Full collector name.

Active Years

: Known period of collecting activity.

Notes

: Biographical or collection-related information.

# Glossary

Accepted Taxon

: Taxon recognised by the adopted authority source.

OTU

: Operational Taxonomic Unit.

Species File

: The taxonomic authority used as the basis for this project.

RBINS

: Royal Belgian Institute of Natural Sciences.

Synonym

: Alternative scientific name referring to the same taxon.

Taxonomic Backbone

: Authoritative hierarchical classification used to organise collection data.

Rank Determination

Family, Subfamily and Tribe are inferred from the upper
taxonomy hierarchy.

Genus, Species and Subspecies are determined using the
parsed scientific name:

- 1 part = Genus
- 2 parts = Species
- 3 parts = Subspecies

