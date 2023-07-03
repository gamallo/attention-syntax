#!/usr/bin/perl -w

@line=();
while ($line = <STDIN>) {
    chomp $line;
    
    if ($line =~ /tensor\(\[\[\[\[/) {
	($first) = ($line =~ /^(.*?)tensor/);
	($second) = ($line =~ /tensor(.*?)$/);
        push @line, $first ;
	push @line, "tensor$second";
    }

    else {
	push @line, $line;
    }

}

for ($i=0;$i<=$#line;$i++) {
    if ($line[$i] =~ /[\d]\,$/ && $line[$i+1] =~ /[\d]\,$/  && $line[$i+2] =~ /[\d]\,$/){
       
       $line[$i] = $line[$i] . " " . $line[$i+1]  . " " . $line[$i+2] . " " . $line[$i+3] ;
       $line[$i] =~ s/[\s\s]+/ /g; 
       print "$line[$i]\n";
       $i+=3;
    }
    elsif ($line[$i] =~ /[\d]\,$/ && $line[$i+1] =~ /[\d]\,$/){

       $line[$i] = $line[$i] . " " . $line[$i+1]  . " " . $line[$i+2] ;
       $line[$i] =~ s/[\s\s]+/ /g;
       print "$line[$i]\n";
       $i+=2;
    }

    elsif ($line[$i] =~ /[\d]\,$/){
       $j=$i+1;
       $line[$i] = $line[$i] . " " . $line[$j];
       $line[$i] =~ s/[\s\s]+/ /g;
       print "$line[$i]\n";
       $i++;
    }

    else {
       print "$line[$i]\n";  
    } 
}
