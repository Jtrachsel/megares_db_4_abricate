# megares_db_4_abricate


### MEGARes db was obtained here:  
wget https://megares.meglab.org/download/megares_v2.00.zip
unzip megares_v2.00.zip


### The Rscript included in this directory was used to create the abricate formatted version of this db.  
### also removes SNP dependent sequences.  

### How to setup this database for use with abricate:
1. Download and unzip the abricate_megares_reduced.fasta.gz file from this repo.  
2. Ceate a 'megares' directory where abricate looks for databases.  Can run the `abricate --datadir` command to find this path.  
3. Move the decompressed fasta into this new directory with the name `sequences`.  
4. Run `abricate --setupdb`.  

### For example, this is how I configured it on my system:  
`cd ~/reference/`
`git clone https://github.com/Jtrachsel/megares_db_4_abricate.git`
`cd megares_db_4_abricate`
`gunzip abricate_megares_reduced.fasta.gz `
`cd /home/julian.trachsel/miniconda3/db # wherever your abricate install looks for dbs`
`mkdir megares`
`cp ~/reference/megares_db_4_abricate/abricate_megares_reduced.fasta ./megares/sequences`
`abricate --setupdb`
