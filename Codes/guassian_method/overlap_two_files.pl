
use strict;

my $filename1 = $ARGV[0];
my $filename2 = $ARGV[1];


my $nfile1=1;
my $nfile2=1;
my $nn;
my $nm;
my $n1;
my $line;
my @data1=();
my @data2=();
my $i1=0;
my $i2=0;
my $line1;
my $line2;
my $i;
my $j;
my $k;
my $start1=0;
my $end1=0;
my $start2=0;
my $end2=0;
my $outname1;
my $outname2;
my $outname3;
my $chr1;
my $chr2;
my $have=0;
my $chrname="ch";
my @position;
my @name;
my $Pointer;
my @pp;
my $rtffile;
my $Intergenic=0;
my $Generegion=0;

@position[1]=1;


	$i1=0;
	$i2=0;
	$Intergenic=0;
	$Generegion=0;
	
	open(IN1,"$filename1") or die "read error";	
	while($line1=<IN1>)
	{
		chomp $line1;
		@data1[$i1]=$line1;
		$i1++;
	}
	close IN1;
		
	$Pointer=0;
	$rtffile=$filename2;
	open(IN2,"$rtffile") or die "read error";	
	while($line2=<IN2>)
	{
		chomp $line2;							
		my @temp = split(/	/,$line2);
		if($chrname ne @temp[0])
		{
			$Pointer++;
			@position[$Pointer]=$i2;
			$chrname = @temp[0];
			@name[$Pointer]=$chrname;
		}
			@data2[$i2]=$line2;
			$i2++;
		}
	close IN2;		

	open (OUT1,">$filename1.overlap");
	open (OUT2,">$filename1.non_overlap");
	
	print "ok$i1\t$i2\n";
	
	for($j=1;$j<=$Pointer;$j++){@pp[$j]=0;}
	
	my $change=0;
	
	
	for($i=0;$i<$i1;$i++)
	{
		my @temp1 = split(/	/,@data1[$i]);
		$chr1=@temp1[0];	
		$start1=@temp1[1];
		$end1=@temp1[2];
	#	$start1=@temp1[1]-1000;
	#	$end1=@temp1[1]+1000;	
	
		$have=0;
		for($j=1;$j<=$Pointer;$j++)
		{
			if($chr1 eq @name[$j])
			{
				
				$k=@position[$j]+@pp[$j];
				my @temp2 = split(/	/,@data2[$k]);
				$chr2=@temp2[0];
				$start2=@temp2[1];
				$end2=@temp2[2];
				
				if($chr1 ne @temp2[0]){next;}
				$change=0;
				
				if($start1>$end2)
				{
					while($start1>$end2)
					{					
						@pp[$j]++;
						$k=@position[$j]+@pp[$j];
											
						my @temp2 = split(/	/,@data2[$k]);
						$chr2=@temp2[0];
						$start2=@temp2[1];
						$end2=@temp2[2];					

						if($chr1 ne $chr2)
						{
							$change=1;
							last;						
						}
							
					}								
				}
				
				if($change==1){next;}
				if($end1<$start2){next;}
						
				if((($start2<=$end1))&&(($start1<=$end2)))
				{
					$have++;
				}
		
			}
		}
		
		if($have==1)
		{
			print OUT1 "@data1[$i]\n";
		}
		else
		{
			print OUT2 "@data1[$i]\n";
		}
		
	}



close OUT1;
close OUT2;

