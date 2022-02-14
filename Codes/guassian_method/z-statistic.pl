use strict;
use Statistics::Basic qw(:all);
open OUT,">zstatistics.txt"or die "open error";
foreach my $kind("300","1000","3000","5000")
{
	open IN,"out-$kind.txt"or die "read error";
	my @region=<IN>;
	my $datai=@region;
	close IN;
	my $tmax=0;
	my $tmin=1000000;
	my @data=();
	for(my $ii=0;$ii<$datai-1;$ii++)
	{
		chomp @region[$ii];
		@region[$ii]=~s/[\n\r]//;
		my @temp=split /\t/,@region[$ii];
		@data[$ii]=@temp[2]-@temp[1]+1;
		if(@data[$ii]>$tmax){$tmax=@data[$ii];}
		if(@data[$ii]<$tmin){$tmin=@data[$ii];}
	}
    my $median = median(@data);
    my $mean   = mean([@data]);	
    print OUT "$kind\t$mean\t$median\t$tmax\t$tmin\n";	
}

close OUT;