#!/usr/bin/perl -w



$layer=0;
$head=0;
while ($line = <STDIN>) {
   
    if ($line =~ /tensor\(\[\[\[\[/) {
	$layer++;
	$head=0;
    }

    if ($line =~ /tensor\(\[\[\[\[/  || $line =~ /\[\[\d/) {
	$head++;
	$token=0;
    }
    if ($line =~ /tensor\(\[\[\[\[/  || $line =~ /\[\[\d/ ||  $line =~ /\[\d/) {
	$token++;
    }
    if ($layer>0 && $line =~ /\[[^\[\]]+\]/)  {
	($vector) = ($line =~ /\[([^\[\]]+)\]/);
	$vector =~ s/\,//g;
	@vector = split (" ", $vector);
       
	#print "$vector -- $layer -- $head -- $token\n";
	for ($i=0;$i<=$#vector;$i++) {
	    $Tensor{$layer}{$head}{$token}[$i] = $vector[$i];
	     #print STDERR "#$vector\n";
        }   
	
    }

}
$tokens = $#vector+1;
foreach $l (sort {$a <=> $b} keys %Tensor) {
   # print STDERR "#$l\n";
    foreach $h (sort {$a <=> $b}  keys %{$Tensor{$l}}) {
        foreach $t (sort {$a <=> $b}  keys %{$Tensor{$l}{$h}}) {
	    for  ($i=0;$i<$tokens;$i++) {
		$j = $i+1;
	       print STDERR "layer=$l head=$h query=$t key=$j value=$Tensor{$l}{$h}{$t}[$i]\n";
	       print "$l $h $t $j $Tensor{$l}{$h}{$t}[$i]\n";
	   }
        }
    }  
}
