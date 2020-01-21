setwd('~/reference/megares/')


library(tidyverse)
library(Biostrings)

mapping <- read_csv('megares_to_external_header_mappings_v2.00.csv')

f1 <- mapping$MEGARes_v2_header


'>DB~~~ID~~~ACC~~~RESISTANCES DESC'
'MEGARes~~~ID'

GENE_NAME <- sub('(.*)\\|(.*)\\|(.*)\\|(.*)\\|(.*)','\\5',f1)
CLASS <- sub('(.*)\\|(.*)\\|(.*)\\|(.*)\\|(.*)','\\4',f1)
RESISTANCE <- sub('(.*)\\|(.*)\\|(.*)\\|(.*)\\|(.*)','\\3',f1)
BROAD_CLASS <- sub('(.*)\\|(.*)\\|(.*)\\|(.*)\\|(.*)','\\2',f1)
ACCNO <- sub('(.*)\\|(.*)\\|(.*)\\|(.*)\\|(.*)','\\1',f1)
DB <- rep('MEGARes', length(ACCNO))

DESC <- paste(BROAD_CLASS, CLASS, sep = '|')

first_part <- paste(DB, GENE_NAME, ACCNO, RESISTANCE, sep = '~~~')

abricate_header <- paste(first_part, DESC, sep = ' ')

ACCNO[1]
first_part[1]
abricate_header[1]


names_df <- data.frame(new=abricate_header, old=f1) %>% write_tsv('fasta_header_map.tsv')

megares_orig <- readDNAStringSet('megares_full_database_v2.00.fasta')

names(megares_orig) == names_df$old

names(megares_orig) <- names_df$new

writeXStringSet(megares_orig, filepath = 'abricate_megares.fasta')

need_SNP <- grep('Require',names(megares_orig))
# need_SNP
megares_reduced <- megares_orig[-need_SNP]

writeXStringSet(megares_reduced, filepath = 'abricate_megares_reduced.fasta')


