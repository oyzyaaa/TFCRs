use strict;
use warnings;

my $nfile1=1; 
my ($dirname1, $dirname4);
my $combine=$ARGV[0];
if( $combine eq "TF" ){
	$dirname1 = "./d_motif_combine/";
	$dirname4 = "./e_tfpos_combine/";
}
if( $combine eq "TFfamily" ){
	$dirname1 = "./d_tffamily_motif_combine/";
	$dirname4 = "./e_tffamily_tfpos_combine/";
}

opendir(DIR,$dirname1)|| die "Can't open directory $dirname1"; 
my @filename1 = readdir(DIR); 
foreach   (@filename1){ 
         $nfile1++;
} 
closedir DIR; 
@filename1=sort{$a cmp $b}@filename1;


for(my $nn=0;$nn<$nfile1-1;$nn++)
{
	if(($filename1[$nn] eq ".")||($filename1[$nn]eq "..")){next;}
	#if($filename1[$nn] !~ /2cell|8cell|icm/){next;}
	opendir(DIR2,"$dirname1$filename1[$nn]")|| die "Can't open directory"; 
	my @filename2 = readdir(DIR2);
	my $nft=@filename2;
	print "$filename1[$nn]\n";
	if(!(-e "$dirname4")){mkdir $dirname4;}
	my @data=();
	my $datai=0;
	foreach my $intf(@filename2)#
	{
		if($intf eq "." ||$intf eq ".."){next;}

		open IN,"$dirname1$filename1[$nn]/$intf"or die "read error";
		while(my $line=<IN>)
		{
			chomp $line;
			$line=~s/[\n\r]//;
			my @temp=split /\t/,$line;
			my $tpos=int (($temp[1] + $temp[2])/2);
			$data[$datai]="$temp[0]\t$tpos";
			$datai++;
		}
		close IN;
	}
	print "total number:\t$datai\n";
	@data=sort{(split /\t/,$a)[1] <=> (split /\t/,$b)[1]}@data;
	print "ok1\n";
	@data=sort{(split /\t/,$a)[0] cmp (split /\t/,$b)[0]}@data;
		
	open OUT,">$dirname4$filename1[$nn].txt"or die "error write $dirname4$filename1[$nn].txt\n";
	my $prechr="";
	my $prePos=-1000;
	my $num=0;
	foreach(@data)
	{
		my @temp=split /\t/,$_;
		if(($prechr ne $temp[0])||($temp[1] ne $prePos))
		{
			if(!$prechr)
			{
				$prechr = $temp[0];
				$prePos = $temp[1];
				$num++;			
				next;
			}			
			print OUT "$prechr\t$prePos\t$num\n";				
		
			$prechr = $temp[0];
			$prePos = $temp[1];
			$num=0;		
		}
		$num++;
		#$prePos = $temp[1];			
	}
	print OUT "$prechr\t$prePos\t$num\n";
	close OUT;
	
}