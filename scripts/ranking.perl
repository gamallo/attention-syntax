#!/usr/bin/perl -w

#$file = shift(@ARGV);
#open (FILE, $file) or die "O ficheiro n�o pode ser aberto: $!\n";



my @heads;
my @layers;
my @all;

while ($line = <STDIN>) {
    chomp $line;
    (@line) = split (" ", $line);
    
    if ($#line == 4) {
        ($l,$h,$freq,$score,$deps) = split (" ", $line);
	$ScoreHead{$l,$h} = $score;
	$DepHead{$l}{$h} = $deps;
	#print STDERR "--#$l# - #$score#\n";
    }
    elsif ($#line == 3) {
	($l,$freq,$score,$deps) = split (" ", $line);
	$ScoreLayer{$l} = $score;
	$DepLayer{$h} = $deps;
    }
     elsif ($#line == 2) {
	($freq,$score,$deps) = split (" ", $line);
	$Score = $score;
	$Dep = $deps;

    }

}

foreach $index (sort   {$ScoreHead{$b} <=> $ScoreHead{$a} } 
	    keys %ScoreHead ) {
             ($l, $h) = split (/$;/o, $index);
	     print "$l $h $ScoreHead{$l,$h}\n";
    
}

foreach $l (sort   {$ScoreLayer{$b} <=> $ScoreLayer{$a} } 
	    keys %ScoreLayer ) {
	     print "$l $ScoreLayer{$l}\n";
    
}
print "$Score\n";
