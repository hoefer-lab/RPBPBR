#!/usr/bin/perl -w
#
#########################################
# This file is part of RPBPBR
# 
# Author:
#   Xi Wang, Xi.Wang at dkfz.de
#
#########################################
#

use strict;
my $usage = "$0 <infile> <outfile>\n";
my $infile = shift || die $usage;
my $outfile = shift || die $usage;

my %len; # pb reads' length
my %pos2seg; 
open(IN, $infile) || die "Can't open $infile for reading!\n";
while(<IN>) { 
  chomp; 
  if(/^\@/) {
    next unless /^\@SQ/; 
    /SN:(.*)\tLN:(\d+)$/; 
    $len{$1} = $2; 
    next;
  }
  my @a = split; 
  my @b = split /|/, $a[0]; 
  my $seg = $a[1] & 0x10 ? $b[0] : $b[1]; 
  #print join "\t", ($a[2], $a[3], $seg), "\n";
  $pos2seg{$a[2]}{$a[3]} = $seg; 
}
close IN;

open(OUT, ">$outfile") || die "Can't open $outfile for writing!\n";
foreach my $pb (sort keys %pos2seg) { 
  print OUT $pb."\t"; 
  my %sub = %{$pos2seg{$pb}}; 
  my @pos = sort {$a<=>$b} keys %sub; 
  my $out; 
  if($pos[0] < 45) { 
    $out = "5'-$sub{$pos[0]}"; 
  } else { 
    $out = "5'-X-$sub{$pos[0]}";
  }
  for(my $i=1; $i<@pos; $i++) {
    my $n = int(($pos[$i] - $pos[$i-1]) / 212 - 0.5);
    for(my $j=0; $j<$n; $j++) { 
      $out .= "-X"; 
    }
    $out .= "-$sub{$pos[$i]}";
  }
  my $n = int(($len{$pb} - $pos[-1]) / 212 - 0.5);
  for(my $j=0; $j<$n; $j++) { 
    $out .= "-X"; 
  }
  $out .= "-3'"; 
  # check the 3' end
  print OUT $out."\n"; 
}
close OUT;
