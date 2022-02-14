use strict;

my $tfcr="TFCR_embryo";
my $indir = $ARGV[0]; ##fimo outputdir, e.g. "Human_GSE101571";
my $combine = $ARGV[1]; # TF ; TFfamily ;
my $motifMap = $ARGV[2]; # Homo_sapiens_2020_0920/TF_Information_all_motifs_plus.txt";
system("perl $tfcr/d-motif_combine.pl $indir $combine $motifMap");
system("perl $tfcr/e-tfpos_combine.pl $combine");
system("perl $tfcr/f1-tf_bed-new-c.pl $combine");
system("perl $tfcr/0-merge-TFCR.pl $indir $combine");
#system("perl $tfcr/f2-delete-overlap.pl $combine");
