use strict;
use warnings;
my $dirname1 = $ARGV[0]; #"."
my $combine = $ARGV[1]; # TF ; TFfamily ;
my @files;
if($combine eq "TFfamily"){
    @files = glob("$dirname1/f_tffamily_tfbed/*.fimo.txt");
    mkdir "$dirname1/f_tffamily_tfbed_merge/" unless -e "$dirname1/f_tffamily_tfbed_merge/";
}else{
    @files = glob("$dirname1/f_tfbed/*.fimo.txt");
    mkdir "$dirname1/f_tfbed_merge/" unless -e "$dirname1/f_tfbed_merge/";
}
print "@files\n";


foreach my $f(@files){
    print $f."\n";
    my $out = $f;
    $out =~ s/_tfbed/_tfbed_merge/;
    system("awk 'NF==5' $f | bedtools sort -i - | bedtools merge -i - -d -1 -c 4,5 -o max > $out");
    #print("bedtools merge -i $f -d -1 -c 4,5 -o max > $out\n");
}