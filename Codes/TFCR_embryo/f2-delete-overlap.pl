use strict;
my $nfile1=1;
my ($dirname1, $dirname4);
my $combine=$ARGV[0];
if( $combine eq "TF" ){
	$dirname1 = "./f_tfbed/";
	$dirname4 = "./f_tfbed_short/";
}
if( $combine eq "TFfamily" ){
	$dirname1 = "./f_tffamily_tfbed/";
	$dirname4 = "./f_tffamily_tfbed_short/";
}

if(!(-e "$dirname4")){mkdir $dirname4;}

opendir(DIR,$dirname1)|| die "Can't open directory $dirname1"; 
my @filename1 = readdir(DIR); 
foreach (@filename1){ 
         $nfile1++;
} 
closedir DIR; 
for(my $nn=0;$nn<$nfile1-1;$nn++)
{
	if(($filename1[$nn] eq ".")||($filename1[$nn]eq "..")){next;}
	#if($filename1[$nn] !~ /2cell|8cell|icm/){next;}  
	open IN,"$dirname1$filename1[$nn]"or die "read error";
	my @data=();
	my $datai=0;
	while(my $line=<IN>)
	{
		chomp $line;
		$line=~s/[\n\r]//;
		$data[$datai]=$line;
		$datai++;
	}
	close IN;

	@data=sort{(split /\t/,$a)[1] <=> (split /\t/,$b)[1]}@data;
	@data=sort{(split /\t/,$a)[0] cmp (split /\t/,$b)[0]}@data;
			
	my($ochr,$ostart,$oend,$ostand,$opvalue)=split /\t/,$data[0];
	open OUT,">$dirname4$filename1[$nn]"or die "error write $dirname4$filename1[$nn]\n";
	foreach(@data)
	{
		my @temp=split /\t/,$_;
		if(($ochr eq $temp[0])&&($temp[1]<=$oend)&&($ostart<=$temp[2]))
		{
			if($opvalue<$temp[4])
			{
				$ostart=$temp[1];
				$oend=$temp[2];
				$ostand=$temp[3];
				$opvalue=$temp[4];
			}
						
		}
		else
		{
			print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\n";
			$ochr=$temp[0];
			$ostart=$temp[1];
			$oend=$temp[2];
			$ostand=$temp[3];
			$opvalue=$temp[4];
		}
	}
	print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\n";
	close OUT;
}