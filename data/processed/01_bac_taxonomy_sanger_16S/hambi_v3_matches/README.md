# Primers

```
>HAMBI_341F
CCTACGGGAGGCAGCAG
>HAMBI_518R
ATTACCGCGGCTGCTGG

# Reverse complement of reverse (for searching alignments)
>HAMBI_518R_rcomp
CCAGCAGCCGCGGTAAT
```

# Command to generate files

```sh
seqkit amplicon -F CCTACGGGAGGCAGCAG -R ATTACCGCGGCTGCTGG 16S_rRNA_SynCom.fasta | seqkit rmdup -s -D 16S_rRNA_SynCom_v3_duplicated_ids.txt -d 16S_rRNA_SynCom_v3_duplicated.fna > 16S_rRNA_SynCom_v3_deduplicated.fna
```

# Files

##  16S_rRNA_SynCom.fasta
All 51 full length 16S sequences

See this spreadsheet:
https://docs.google.com/spreadsheets/d/1ABAn1Wg0H9Z2Ql0qIiIC98_47GMwQfAzVTUBdViqoiQ/edit?gid=781850260#gid=781850260

##  16S_rRNA_SynCom_v3_duplicated_ids.txt
Identifiers of duplicated v3 sequences in clusters. First v3 sequence in each cluster list is the "representative"

##  16S_rRNA_SynCom_v3_duplicated.fna
Fasta formatted v3 sequences of duplicated sequences in clusters.

##  16S_rRNA_SynCom_v3_deduplicated.fna
Only unique v3 sequences from `16S_rRNA_SynCom.fasta`. Duplicated sequences are represented by single cluster representative
