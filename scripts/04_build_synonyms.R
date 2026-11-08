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