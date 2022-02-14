use strict;


my $dirname1="./e_tfpos_combine/";
my ($dirname1, $dirname4);
my $combine=$ARGV[0];
if( $combine eq "TF" ){
	$dirname1 = "./e_tfpos_combine/";
	$dirname4="./f_tfbed/";
}
if( $combine eq "TFfamily" ){
	$dirname1 = "./e_tffamily_tfpos_combine/";
	$dirname4="./f_tffamily_tfbed/";
}

opendir(DIR,$dirname1)|| die "Can't open directory $dirname1"; 
my @filename1 = readdir(DIR); 
closedir DIR; 
my @runfile=();
my $runi=0;
foreach (@filename1)
{ 
	if(($_ eq ".")||($_ eq "..")){next;}
    #if($_ !~ /2cell|8cell|icm/){next;}  
    $runfile[$runi]=$_;
    $runi++;
} 
print "$runi\n";

if(!(-e "$dirname4")){mkdir $dirname4;}

for(my $nn=0;$nn<$runi;$nn++)
#for(my $nn=325;$nn<$runi;$nn++)
{
	#if(-e "$dirname4$runfile[$nn]"){next;}
	my $command="../guassian_method/guassian_300 $dirname1$runfile[$nn] $dirname4$runfile[$nn]";
	print "$command\n";
	system("$command");
}
