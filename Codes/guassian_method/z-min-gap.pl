use strict;
use Statistics::Basic qw(:all);
foreach my $kind("300","1000","3000","5000")
{
	open IN,"out-$kind.txt"or die "read error";
	my @region=<IN>;
	my $datai=@region;
	close IN;
	my @gapt=();
	my $gi=0;
	open OUT,">./zgap/$kind.txt"or die "open error";
	for(my $ii=0;$ii<$datai-1;$ii++)
	{
		my @temp1=split /\t/,@region[$ii];
		my @temp2=split /\t/,@region[$ii+1];
		if(@temp1[0] eq @temp2[0])
		{
			if(@temp2[1]-@temp1[2]>0)
			{
				@gapt[$gi]=@temp2[1]-@temp1[2];
				$gi++;
			}
		
		}
	}
	@gapt=sort{$a <=> $b}@gapt;
	
    foreach(@gapt)	
    {
    	print OUT "$_\n";
    }
    close OUT;
}
