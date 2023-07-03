#!/usr/bin/perl -w

$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro n�o pode ser aberto: $!\n";



while ($line = <FILE>) {
    chomp $line;
    ($idf, $token, $synt) = split ('\t', $line);
    if ($synt eq "-") {next}
    (@rel) = split ('\,', $synt);
    foreach $rel (@rel) {
	($t,$d) = split ("_", $rel);
	$Dep{$idf}{$t} = $rel;
	$Trans{$idf} = $token;
	$Count++;
	$FoundDep{$rel}=0;
	$FoundHeadDep{$rel}=0;
	$FoundLayerDep{$rel}=0;
	print  STDERR "---->$idf -- $t\n";
    }
}
my $N=$idf;

my @heads;
my @layers;
my @all;


foreach $d (sort keys %FoundDep) {
 $DEP_NONE .= "|" . $d . ":" . 0 ;
}

while ($line = <STDIN>) {
    chomp $line;
    (@line) = split (" ", $line);
    
    if ($#line == 4) {
	push (@heads, $line);
    }
    elsif ($#line == 3) {
	push (@layers, $line);
    }
     elsif ($#line == 2) {
	push (@all, $line);
    }

}

for ($i=0;$i<=$#heads;$i++) {
    #print STDERR "$heads[$i]\n";
    $sent=$i+$N;
    for ($j=$i;$j<=$sent;$j++) {
      if (!$heads[$j]) {next}
      $line = $heads[$j];
      ($l,$h,$q,$k,$v) = split (" ", $line);
      # print STDERR "$l - $h - $q -- $k\n";
      $HEADS{$l}{$h}++;
      
      if ($Dep{$q}{$k} &&  !$NotFoundHead{$l}{$h}{$q} && !$FoundHead{$l}{$h}{$q}) {
	       if ($k != 1 && $k != $N) { 
		   print STDERR "$q -- $k\n";   
		   $FoundHead{$l}{$h}{$q}++;
		   $Head{$l}{$h}++;
		   $dep = $Dep{$q}{$k};
		   $FoundHeadDep{$l}{$h}{$dep}++;
	       }
		   
      }
      else {
	       $NotFoundHead{$l}{$h}{$q}++;
	       # print STDERR "$q -- $k\n";  
		     #next;
	
      }
    }
    $i = $i+$N-1;
}

for ($i=0;$i<=$#layers;$i++) {
     #print STDERR "$layers[$i]\n";
    $sent=$i+$N;

    for ($j=$i;$j<=$sent;$j++) {
       if (!$layers[$j]) {next}
       $line = $layers[$j];
       ($l,$q,$k,$v) = split (" ", $line);
       $LAYERS{$l}++;
       #print STDERR "$l $q $k\n";
       #if ($k == $q){next}
       if ($Dep{$q}{$k} &&  !$NotFoundLayer{$l}{$q} && !$FoundLayer{$l}{$q}) {
	     if ($k != 1 && $k != $N) {  
		   print STDERR "$l -- $q -- $k :: #$line#\n";   
		   $FoundLayer{$l}{$q}++;
		   $Layer{$l}++;
		   $dep = $Dep{$q}{$k};
		   $FoundLayerDep{$l}{$dep}++;
	     }
		   
      }
      elsif  (!$Dep{$q}{$k} ) { 
		     $NotFoundLayer{$l}{$q}++;
		     #next;
	
      }
    }
    $i = $i+$N-1;
}

$FoundAll=0;
for ($i=0;$i<=$#all;$i++) {
    $sent=$i+$N;
    
    for ($j=$i;$j<=$sent;$j++) {
      if (!$all[$j]) {next}  
      $line = $all[$j];
      ($q,$k,$v) = split (" ", $line);
      print STDERR "$q -- $k :: #$line#\n";
      #if ($k == $q){next}
      if ($Dep{$q}{$k} &&  !$NotFound{$q} && !$Found{$q}) {
	        if ($k != 1 && $k != $N) {  
		   print STDERR "$l -- $q -- $k :: #$line#\n";   
		   $Found{$q}++;
		   $FoundAll++;
		   $dep = $Dep{$q}{$k};
		   $FoundDep{$dep}++;
		}
      }
      else {
	          $NotFound{$q}++;
		     #next;
	
      }
    }
    $i = $i+$N-1;
}

  

foreach $l (sort keys %FoundHead) {
    
    foreach $h (sort keys %{$FoundHead{$l}}) {
	 $DEP="";
         foreach $d (sort keys %FoundDep) {
	     if ($FoundHeadDep{$l}{$h}{$d}) {
		 $DEP .= "|" . $d . ":" . $FoundHeadDep{$l}{$h}{$d} ;
	     }
	     else {
                $DEP .= "|" . $d . ":" . 0 ;
	     }
         }
	 $score =  $Head{$l}{$h} / $Count;
	 print "$l $h $Head{$l}{$h} $score $DEP\n";
	 #foreach $q (sort keys %{$FoundHead{$l}{$h}}) { ##aqui é por palavra, mas não sei se vale a pena esta info
            #print STDERR "$l $h $q $FoundHead{$l}{$h}{$q}\n";
         #}
    }
    foreach $h (sort keys %{$HEADS{$l}}) {
	if  (!$Head{$l}{$h}) {
	  print "$l $h 0 0 $DEP_NONE\n";  
	}
    }
}

foreach $l (sort keys %FoundLayer) {
        $DEP="";
	#foreach $d (sort keys %{$FoundLayerDep{$l}}) {
	foreach $d (sort keys %FoundDep) {
	    if ($FoundLayerDep{$l}{$d}) {
		$DEP .= "|" . $d . ":" . $FoundLayerDep{$l}{$d} ;
	    }
	    else{
	       $DEP .= "|" . $d . ":" . 0 ;
	    }
	}
	$score =  $Layer{$l} / $Count;
	print "$l $Layer{$l} $score $DEP\n";
	#foreach $q (sort keys %{$FoundLayer{$l}}) {
            #print STDERR "$l $q $FoundLayer{$l}{$q} $NotFoundLayer{$l}{$q}\n";
        #}
}
foreach $l (sort keys %LAYERS) {
	if  (!$Layer{$l}) {
	  print "$l 0 0 $DEP_NONE\n";  
	}
}

$DEP="";
foreach $d (sort keys %FoundDep) {
    $DEP .= "|" . $d . ":" . $FoundDep{$d} ;
}
$score =  $FoundAll / $Count;
print "ALL:$FoundAll $score $DEP\n";
#foreach $q (sort keys %Found) {
    
#	 print "$q $Found{$q}\n";
#}

