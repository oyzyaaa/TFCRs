use strict;

my $tfcr="/public2/home/ouyang/ShortProject/SP6_TFCR/TCGA_TFCR/TFCR_embryo";
my $indir = $ARGV[0]; ##fimo output, e.g. "Human_GSE101571";
my $combine = $ARGV[1]; # TF_TOBIAS; TFfamily_TOBIAS;
my $motifMap = $ARGV[2]; # Homo_sapiens_2020_0920/TF_Information_all_motifs_plus.txt";
system("perl $tfcr/d-motif_combine-TOBIAS.pl $indir $combine $motifMap");
system("perl $tfcr/e-tfpos_combine.pl $combine");
system("perl $tfcr/f1-tf_bed-new-c.pl $combine");
system("perl $tfcr/f2-delete-overlap.pl $combine");
