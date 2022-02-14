use strict;

open IN,"out-3000-03.txt"or die "read error";
my @data=();
my $datai=0;
while(my $line=<IN>)
{
	chomp $line;
	$line=~s/[\n\r]//;
	@data[$datai]=$line;
	$datai++;
}
close IN;

@data=sort{(split /\t/,$a)[1] <=> (split /\t/,$b)[1]}@data;
@data=sort{(split /\t/,$a)[0] cmp (split /\t/,$b)[0]}@data;
		
my($ochr,$ostart,$oend,$ostand,$opvalue)=split /\t/,@data[0];
open OUT,">z_combine3000-03.txt"or die "open error";
foreach(@data)
{
	my @temp=split /\t/,$_;
	if(($ochr eq @temp[0])&&(@temp[1]<=$oend)&&($ostart<=@temp[2]))
	{
		if($opvalue<@temp[4])
		{
			$ostart=@temp[1];
			$oend=@temp[2];
			$ostand=@temp[3];
			$opvalue=@temp[4];
		}
					
	}
	else
	{
		print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\n";
		$ochr=@temp[0];
		$ostart=@temp[1];
		$oend=@temp[2];
		$ostand=@temp[3];
		$opvalue=@temp[4];
	}
}
print OUT "$ochr\t$ostart\t$oend\t$ostand\t$opvalue\n";
close OUT;
