library(tidyverse)
library(Biostrings)

# read in fasta_header mappings
mapping <- read_csv('megares_to_external_header_mappings_v2.00.csv') 

# split out info we need to build abricate fasta header
# and build abricate fasta header
test <- 
  mapping %>% 
  separate(MEGARes_v2_header, sep = '\\|', remove = FALSE, extra = 'merge',
           into = c('ACCNO', 'BROAD_CLASS', 'RESISTANCE', 'CLASS', 'GENE_NAME')) %>% 
  mutate(DESC=paste(BROAD_CLASS, CLASS, sep = '|')) %>% 
  mutate(first_part=paste(Database, GENE_NAME, ACCNO, RESISTANCE, sep = '~~~'), 
         abricate_header=paste(first_part, DESC, sep = ' '))

# this defines the genes we want in the final product
# Goal here is to only keep the metal/biocide resistance from BacMet database
GOOD_GENES <- 
  test %>%
  filter(BROAD_CLASS != 'Drugs') %>% 
  filter(Database == 'BacMet') %>%
  filter(!(grepl('Requires',GENE_NAME))) %>% 
  pull(abricate_header)

# read in the megares db fasta
megares_orig <- readDNAStringSet('megares_modified_database_v2.00.fasta')

# check that the fasta headers we expect are there
all(names(megares_orig) == test$MEGARes_v2_header)

# rename the sequences in the megares db (this will set fasta headers)
names(megares_orig) <- test$abricate_header

# write out the megares database with abricate style fasta headers
writeXStringSet(megares_orig, filepath = 'abricate_megares.fasta')

# generate a vector of indexes corresponding to genes we want in the final 
# abricate fasta
KEEPERS <- which(names(megares_orig) %in% GOOD_GENES)

# subset the megares fasta to only BacMet Metals/Biocides
megares_reduced <- megares_orig[KEEPERS]

# write out the metals/biocides fasta
writeXStringSet(megares_reduced, filepath = 'abricate_megares_reduced.fasta')


