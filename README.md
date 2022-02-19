## Identification of transcription factor binding sites clustered regions

First, the TFBSs were identified from ATAC-seq peaks by FIMO. The position-specific weight matrices (PWMs) of transcription factors were downloaded from CIS-BP databases. The genomic sequences under the open chromatin regions were used as inputs for FIMO with a custom library of all motifs for each species to scan for motif instances at a p-value threshold of 1e-5. 

Then, an established method was used to identify TFCRs by performing the Gaussian kernel density estimations across the genome (with a bandwidth of 300bp centered on each TFBS). Each peak in density profile was considered a TFCR. To determine the complexity of each TFCR, the Gaussian kernelized distances from each peak that contributed at least 0.1 to its strength were determined. The complexity of each TFCR was determined by the quantity and proximity of the contributing TFBS. We combined motif instances based on the TF family information from CIS-BP to calculate the complexity of TFCR. The window for each TFCR was determined by finding the maximum distance (in bp) from the TFCR to a contributing TF and then adding 150 bp (one-half of the bandwidth). Each window was centered on the TFCR. The identified TFCR was grouped into 10 groups based on their complexity from low to high. 

usage:
indir="Human_fimo" # the directory where you put the output files of FIMO\n
motifMap="Homo_sapiens_2020_0920/TF_Information_all_motifs_plus.txt" # the mapping relationship of TF and its TF family from CIS-BP\n
cd Codes/TFCR_embryo\n
perl d-motif_combine.pl $indir TFfamily $motifMap
perl $tfcr/e-tfpos_combine.pl TFfamily
perl $tfcr/f1-tf_bed-new-c.pl TFfamily
perl $tfcr/0-merge-TFCR.pl $indir TFfamily
