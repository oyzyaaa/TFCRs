{\rtf1\ansi\ansicpg936\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs36 \cf0 Use strict;\
Use warnings;\
\
My $input = \'93Homo.motif.all.txt\'94;\
My $out = \'93TF_motif_map.txt\'94;\
My (@a,%tf);\
open(F1,$input) || die\'94error open $input\\n\'94;\
while(<F1>)\
\{\
	@a = split/\\t/,$_;\
	if( !exists $a[xx] )\
	\{\
		$tf\{ $a[xx] \} = $a[ss];\
	\}\
	else\
	\{\
		$tf\{ $a[xx] \} = $tf\{$a[ss]\}.\'94\\t\'94.$a[ss];\
	\}\
\}\
close F1;\
\
open( Fo, \'93>$out\'94) || die \'93 error write $out\\n\'94;\
for each my $tfgene (sort keys %tf)\
\{\
	print Fo $tfgene;\
	@a = split/\\t/,$tf\{ $tfgene\};\
	my %reDup;\
	foreach my $motif (@a[1..@a])\
	\{\
		if(! exists $reDup\{ $motif\} )\
		\{\
			print Fo \'93\\t\'94.$motif;\
			$reDup\{ $motif\} = 1;\
		\}\
	\}\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 	print Fo \'93\\n\'94;\
\}\
close Fo;\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 			\
\
}