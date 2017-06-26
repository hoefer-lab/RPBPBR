#!/usr/bin/perl -w
#
########################################
# This file is part of RPBPBR
# 
# Author:
#   Xi Wang, Xi.Wang at dkfz.de
#
########################################

use strict;
my $usage = "$0 <input.fa> <adapter.mapping> <trimmed.fa> <remaining.fa>\n";
my $fafile = shift || die $usage;
my $infile = shift || die $usage;
my $outfile = shift || die $usage;
my $outfile2 = shift || die $usage;

open(FA, $fafile) || die "Can't open $fafile for reading!\n";
my (%seq, $id); 
while(<FA>) { 
  chomp; 
  if(/^>/) {
    s/>//;
    $id = $_;
  } else { 
    if(exists $seq{$id}) { 
      $seq{$id} .= $_;
    } else { 
      $seq{$id} = $_;
    }
  }
}
close FA; 
#foreach $id (keys %seq) { print join "\t", ($id, $seq{$id}), "\n"; } 

open(IN, $infile) || die "Can't open $infile for reading!\n";
my (%adapter3, %adapter5, $rev_flag); 
while(<IN>) { 
  my @a = split; 
  $rev_flag = 0; 
  $rev_flag = 1 if($a[1] & 0x10); 
  $a[3] --; 
  unless($rev_flag) { 
    # shift pos to end of the adapter
    my $read_len_on_ref = &cigar_len($a[5]); 
    $a[3] += $read_len_on_ref; 
  }
  if($a[0] =~ /adapter3/) {
    $a[3] = - $a[3] unless($rev_flag);
    push @{$adapter3{$a[2]}}, $a[3];
  }
  if($a[0] =~ /adapter5/) {
    $a[3] = - $a[3] if($rev_flag);
    push @{$adapter5{$a[2]}}, $a[3];
  }
}
close IN;

open(OUT, ">$outfile") || die "Can't open $outfile for writing!\n";
open(OUT2, ">$outfile2") || die "Can't open $outfile2 for writing!\n";

foreach $id (keys %seq) { 
  unless(exists $adapter5{$id} || exists $adapter3{$id}) { 
    print join "\t", ($id, length($seq{$id}), 0), "\n";
    print "##$id fail to find concordant adapters\n";
    print OUT2 ">$id\n$seq{$id}\n"; 
    next;
  }
  # 5' --- 3'rvs
  my %adapter_at_pos; 
  foreach my $p (@{$adapter5{$id}}) {$adapter_at_pos{$p} = 5}; 
  foreach my $p (@{$adapter3{$id}}) {$adapter_at_pos{$p} = 3}; 
  my @pos =  sort {$a <=> $b} keys %adapter_at_pos; 
  print join "\t", ($id, length($seq{$id}), scalar(@pos), @pos), "\n";

  my $i; 
  for($i=0; $i<$#pos; $i++) { 
    last if($adapter_at_pos{$pos[$i]} == 5 && $adapter_at_pos{$pos[$i+1]} == 3 && $pos[$i] * $pos[$i+1] > 0);
  }
  if($i == $#pos) {
    print "##$id fail to find concordant adapters\n";
    print OUT2 ">$id\n$seq{$id}\n"; 
    next;
  }
  #my $p5 = $pos[$i]; 
  #my $p3 = $pos[$i+1];
  my $clean_seq; 
  # TODO check the first and last
  if($pos[$i] > 0) { ## donot need RC
    $clean_seq = substr($seq{$id}, $pos[$i], $pos[$i+1]-$pos[$i]);
  } else { 
    my $tmp = reverse($seq{$id});
    $tmp =~ tr/ACGT/TGCA/;
    $tmp =~ tr/acgt/TGCA/;
    $clean_seq = substr($tmp, length($seq{$id})+$pos[$i], $pos[$i+1]-$pos[$i]);
  }
  print OUT ">", $id, "\n", $clean_seq, "\n";
}
close OUT;

sub cigar_len { 
  my $cigar = $_[0]; 
  my $len = 0; 
  my $tmp; 
  while($cigar =~ /^(\d+)([NMID])/) {
    $len += $1 if($2 eq "M" || $2 eq "N" || $2 eq "D");
    $tmp="$1$2";
    $cigar =~ s/$tmp//;
  }
  return $len; 
}
