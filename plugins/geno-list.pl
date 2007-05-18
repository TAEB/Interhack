# add extended-command #geno to list genocided species
# by Eidolos

my %geno;

extended_command "#geno"
              => sub
                 {
                     my $geno = join ', ', sort keys %geno;
                     $geno = "No genocides." if $geno eq '';
                     pline($geno);
                 };
each_iteration
{
  while (/Wiped out all (.*?)\./g)
  {
    $geno{$1} = 1;
  }
}

