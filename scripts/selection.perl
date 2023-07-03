#!/usr/bin/perl -w

my $frase = shift(@ARGV);
$frase = "CLS " . $frase . " SEP";  
my @frase = split (" ", $frase);

while ($line = <STDIN>) {
    chomp $line;
    ($l,$h,$q,$k,$v) = split (" ", $line);

    $TensorHead{$l}{$h}{$q}{$k} += $v;
    $TensorLayer{$l}{$q}{$k} += $v;
    $Tensor{$q}{$k} += $v;
}

foreach $l (sort {$a <=> $b} keys %TensorHead) {
 foreach $h (sort {$a <=> $b} keys %{$TensorHead{$l}}) {
   foreach $q (sort {$a <=> $b} keys %{$TensorHead{$l}{$h}}) {
        foreach $k (sort   {$TensorHead{$l}{$h}{$q}{$b} <=> 
                              $TensorHead{$l}{$h}{$q}{$a}         } 
		      keys %{$TensorHead{$l}{$h}{$q}} ) {

	      $i=$k-1;
	      my $kk=$frase[$i];
	      $i=$q-1;
	      my $qq=$frase[$i];
	      print "L$l H$h Q_$qq $kk $TensorHead{$l}{$h}{$q}{$k}\n";
	}

    }
  }
}


foreach $l (sort {$a <=> $b} keys %TensorLayer) {

  foreach $q (sort {$a <=> $b} keys %{$TensorLayer{$l}}) {
        foreach $k (sort   {$TensorLayer{$l}{$q}{$b} <=> 
                              $TensorLayer{$l}{$q}{$a}         } 
		      keys %{$TensorLayer{$l}{$q}} ) {

	      $i=$k-1;
	      my $kk=$frase[$i];
	      $i=$q-1;
	      my $qq=$frase[$i];
	      print "L$l Q_$qq $kk $TensorLayer{$l}{$q}{$k}\n";

        }
  }
}

print "\n";

foreach $q (sort {$a <=> $b} keys %Tensor) {
        foreach $k (sort   {$Tensor{$q}{$b} <=> 
                              $Tensor{$q}{$a}         } 
		      keys %{$Tensor{$q}} ) {
	      $i=$k-1;
	      my $kk=$frase[$i];
	      $i=$q-1;
	      my $qq=$frase[$i];
	      print "Q_$qq $kk $Tensor{$q}{$k}\n";

        }  
}
