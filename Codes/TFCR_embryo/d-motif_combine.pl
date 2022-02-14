use strict;
use warnings;

my $nfile1=1; 
my $dirname1= $ARGV[0]; #"./Human_GSE101571/";
my $combine=$ARGV[1]; # TF or TFfamily
my $motifMap=$ARGV[2];# Homo_sapiens_2020_0920/TF_Information_all_motifs_plus.txt";

#------------------function-------------
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

#-------------read in file names--------------
opendir(DIR,$dirname1)|| die "Can't open directory $dirname1"; 
my @filename1 = grep{/fimo.txt/} readdir(DIR); 
foreach (@filename1){
	print $_."\n"; 
    $nfile1++;
} 
closedir DIR; 

#last;

my $input = $motifMap;
my (@a,%tfMap);
open(F1,$input) || die "error open $input\n";
while(<F1>)
{
	@a = split/\t/,$_;
	if( $combine eq "TF" ){# a motif may be related to multiple TFs
		if( !exists $tfMap{ $a[3] }){
			$tfMap{ $a[3] } = $a[0];
		}else{
			$tfMap{ $a[3] } = $tfMap{ $a[3] }."\t".$a[0];
		}
	}
	if( $combine eq "TFfamily" ){
		if( !exists $tfMap{ $a[3] }){
			$tfMap{ $a[3] } = $a[1];
		}else{
			$tfMap{ $a[3] } = $tfMap{ $a[3] }."\t".$a[1];
		}
	}
}
close F1;


foreach my $file( @filename1 )## for loop files in dirname1
{
	#if($file !~ /2cell|8cell|icm/){next;}
	print $file."\n";
	if(($file eq ".")||($file eq "..")){next;}
	my $dirname4;
	if( $combine eq "TF" ){
		if(!(-e "d_motif_combine")){mkdir "d_motif_combine";}	
		$dirname4 = "./d_motif_combine/$file/";
	}
	if( $combine eq "TFfamily" ){
		if(!(-e "d_tffamily_motif_combine")){mkdir "d_tffamily_motif_combine";}
		$dirname4 = "./d_tffamily_motif_combine/$file/";
	}
	
	$dirname4 =~ s/\.txt//;
	print "$dirname4\n";
	#if(-e $dirname4){next;}
	if(!(-e $dirname4)){mkdir $dirname4;}	
	#next;
	my %tfMotif;
	open(IN,"$dirname1$file")|| die "Can't open $dirname1$file\n"; 
	while(my $line=<IN>)
	{
		chomp $line;
		$line=~s/[\n\r]//;
		if($line=~/#pattern/){next;}
		my @temp=split /\t/,$line;
		my $lent=@temp;
		if($lent != 9){print "error\t$temp[0]\t$file\n";next;}			
		my($chrt,$start,$end) = ($temp[1] =~ /(.*):(.*)-(.*)/);
		#print "$chrt,$start,$end\n";
		my $stand = $temp[4];
		if($temp[2]>$temp[3])
		{
			$start=$start+$temp[3]-1;
			$end=$start+$temp[2]-$temp[3];
		}
		else
		{
			$start=$start+$temp[2]-1;
			$end=$start+$temp[3]-$temp[2];				
		}
		my @tfs = split/\t/,$tfMap{$temp[0]}; # a motif related to many TFs
		my @tfUniq = uniq(@tfs); # whether a duplicated TF/TFfamily in motifs
		#print @tfs."\tafterRmDup\t".@tfUniq."\n";
		foreach my $tf (@tfUniq){
			if( !exists $tfMotif{ $tf } )
			{
				$tfMotif{ $tf } = ();
				push @{$tfMotif{$tf}},"$chrt\t$start\t$end\t$stand\t$temp[6]\t$temp[0]";
			}else{
				push @{$tfMotif{$tf}},"$chrt\t$start\t$end\t$stand\t$temp[6]\t$temp[0]";
			}
		}
	}
	close IN;

	#### 
	foreach my $outtf ( sort keys %tfMotif )
	{
		#print $outtf."\n";
		my @data = @{$tfMotif{ $outtf }};
		@data=sort{(split /\t/,$a)[1] <=> (split /\t/,$b)[1]}@data; 
		@data=sort{(split /\t/,$a)[0] cmp (split /\t/,$b)[0]}@data;
		my $dii=@data;
		#print "$data[0]\n";
		my($ochr,$ostart,$oend,$ostand,$opvalue,$omname)=split /\t/,$data[0];
		open OUT,">$dirname4$outtf.txt"or die "error write $dirname4$outtf.txt\n";
		foreach(@data)
		{
			my @temp=split /\t/,$_;
			if(($ochr eq $temp[0])&&($temp[1]<=$oend)&&($ostart<=$temp[2]))# if TFBS within the same TFfamily overlapped, get merged regions
			{
				if($ostart>$temp[1]){$ostart=$temp[1];}
				if($oend<$temp[2]){$oend=$temp[2];}
				if($ostand ne $temp[3]){$ostand="b";}
				if($opvalue>$temp[4]){$opvalue=$temp[4];}
				if($omname ne $temp[5]){$omname="more_than_one";}					
			}
			else
			{
				print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\t$omname\n";
				$ochr=$temp[0];
				$ostart=$temp[1];
				$oend=$temp[2];
				$ostand=$temp[3];
				$opvalue=$temp[4];
				$omname=$temp[5];
			}
		}
		print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\t$omname\n";
		close OUT;		
	}		
}