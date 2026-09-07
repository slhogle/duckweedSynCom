#pak::pkg_install("magler1/AmpStop")

library(AmpStop)
library(tidyverse)
library(here)


AmpStop::get_candidate_oligos(
  nontarget = here::here(
    "data_raw",
    "ampstop",
    "lemna_18S_mitochondria_revcomp_v3v4.fa"
  ),
  length = 30,
  outfile = here::here("data", "ampstop", "18S_candidate_oligos.fasta")
)

AmpStop::blast_candidate_oligos(
  blastn_path = "/home/shane/source/ncbi-blast-2.17.0+/bin/blastn",
  blastdb = here::here(
    "data_raw",
    "ampstop",
    "duckweed_otus_all_bacteria_v3v4"
  ),
  candidates = here::here("data", "ampstop", "18S_candidate_oligos.fasta"),
  outfile = here::here("data", "ampstop", "18S_candidate_vs_duckweed.m8"),
  percid = 25,
  wordsize = 7
)

AmpStop::check_candidate_oligos(
  candidates = here::here("data", "ampstop", "18S_candidate_oligos.fasta"),
  blastoutput = here::here("data", "ampstop", "18S_candidate_vs_duckweed.m8"),
  outputfile = here::here("data", "ampstop", "18S_candidate_oligospairs.txt")
)

oligos <- readr::read_tsv(here::here(
  "data",
  "ampstop",
  "18S_candidate_oligospairs.txt"
))


# forwards
oligos |>
  mutate(lowbound = max(kmer) * 1 / 3, upbound = max(kmer) * 2 / 3) |>
  filter(kmer < lowbound) |>
  arrange(`Hits alignd at 3' End`) |>
  arrange(HitsTotal)

# kmer 102 looks good for the forward
# TTTCGTCGAGTGCGCGATCATGACAGGACTC

# reverse
test <- oligos |>
  mutate(lowbound = max(kmer) * 1 / 3, upbound = max(kmer) * 2 / 3) |>
  filter(kmer > upbound) #|>
#arrange(`Hits alignd at 3' End`) |>
arrange(HitsTotal)

# kmer 371 looks good for the other
# GCAGCTCTCTGGGTCCCTACTGACGCTGGGG
