use strict;

my $nfile1=1; 
my $dirname1=$ARGV[0]; #"./"
my $combine=$ARGV[1]; # TF_TOBIAS or TFfamily_TOBIAS
my $motifMap=$ARGV[2];# Homo_sapiens_2020_0920/TF_Information_all_motifs_plus.txt";

#------------------function-------------
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

#-------------read in file names--------------
opendir(DIR,$dirname1)|| die "Can't open directory $dirname1"; 
my @filename1 = grep{/_TOBIAS_out$/} readdir(DIR); 
foreach   (@filename1){
	print $_."\n";
    $nfile1++;
} 
closedir DIR; 

open IN, $motifMap or die "read error $motifMap\n";
my %tfdata=();
while(<IN>)
{
	chomp;
	my @a=split /\t/,$_;
	my $tfname;
	if( $combine eq "TF_TOBIAS"){
		$tfname = $a[0];
	}
	if( $combine eq "TFfamily_TOBIAS" ){
		$tfname = $a[1];
	}
	if(!$tfdata{$tfname}){
		$tfdata{$tfname} = $a[3];
	}else{
		$tfdata{$tfname} = $tfdata{$tfname}."\t".$a[3];
	}
}
close IN;
my @keytfdata=keys(%tfdata);

#for(my $nn=0;$nn<$nfile1-1;$nn++)
for(my $nn=1;$nn<3;$nn++)
{
	#if(($filename1[$nn] eq ".")||($filename1[$nn]eq "..")){next;}
	#if(($filename1[$nn] ne "LUAD_peakCalls.txt")){next;}
	my $dirname4;

	if( $combine eq "TF_TOBIAS" ){
		if(!(-e "d_motif_combine_TOBIAS")){mkdir "d_motif_combine_TOBIAS";}	
		$dirname4 = "./d_motif_combine_TOBIAS/$filename1[$nn]/";
	}
	if( $combine eq "TFfamily_TOBIAS" ){
		if(!(-e "d_tffamily_motif_combine_TOBIAS")){mkdir "d_tffamily_motif_combine_TOBIAS";}
		$dirname4 = "./d_tffamily_motif_combine_TOBIAS/$filename1[$nn]/";
	}
	if(!(-e $dirname4)){mkdir $dirname4;}	
	opendir(DIR2,"$dirname1$filename1[$nn]")|| die "Can't open directory"; 
	my @filename2 = readdir(DIR2);
	my $nft=@filename2;

	#print "$dirname1$filename1[$nn]\n";
	foreach my $outtf(@keytfdata)
	{
		#if(-e "$dirname4$outtf.txt"){next;}
		#print "$outtf\n";
		my @data=();
		my $datai=0;
		my @motifs=split /\t/,$tfdata{$outtf};
		@motifs = uniq(@motifs);# remove duplicated TF/TFfamiy in one motif
		my $nmotif=@motifs;
		my $nomotif=0;
		for(my $ii=0;$ii<$nmotif;$ii++)
		{
			if(!(-e "$dirname1$filename1[$nn]/$motifs[$ii]_$motifs[$ii]/$motifs[$ii]_$motifs[$ii]_overview.txt")){$nomotif++;next;}
			open IN,"$dirname1$filename1[$nn]/$motifs[$ii]_$motifs[$ii]/$motifs[$ii]_$motifs[$ii]_overview.txt" or die "read error $dirname1$filename1[$nn]/$motifs[$ii]_$motifs[$ii]/$motifs[$ii]_$motifs[$ii]_overview.txt\n";
			while(my $line=<IN>)
			{
				chomp $line;
				$line=~s/[\n\r]//;
				if($line=~/TFBS_chr/){next;}
				my @temp=split /\t/,$line;
				if($temp[10] != 1){ next;}## 1 for bound; 0 for unbound
				my $lent=@temp;
				if($lent <11){print "error\t$motifs[$ii]\t$filename1[$nn]\n";next;}			
				my($chrt,$start,$end, $stand, $TFBSscore)= ($temp[0], $temp[1], $temp[2], $temp[5], $temp[4]);
				@data[$datai]="$chrt\t$start\t$end\t$stand\t$TFBSscore\t$temp[3]";
				$datai++;
			}
			close IN;
		}
		@data=sort{(split /\t/,$a)[1] <=> (split /\t/,$b)[1]}@data;
		@data=sort{(split /\t/,$a)[0] cmp (split /\t/,$b)[0]}@data;
		my $dii=@data;
		if($nomotif>0 && ($dii eq 0)){next;}
		my($ochr,$ostart,$oend,$ostand,$opvalue,$omname)=split /\t/,@data[0];
		open OUT,">$dirname4$outtf.txt"or die "open error";
		foreach(@data)
		{
			my @temp=split /\t/,$_;
			if(($ochr eq $temp[0])&&($temp[1]<=$oend)&&($ostart<=$temp[2]))
			{
				if($ostart>$temp[1]){$ostart=$temp[1];}
				if($oend<$temp[2]){$oend=$temp[2];}
				if($ostand ne $temp[3]){$ostand="b";}
				if($opvalue<$temp[4]){$opvalue=$temp[4];}# higher score means more evidence
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