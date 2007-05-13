# add extended-command #geno to list genocided species
# by Eidolos

my %geno;

extended_command "#geno"
              => sub
                 {
                     my $geno = join ', ', sort keys %geno;
                     $geno = "No genocides." if $geno eq '';
                     if (substr($&, 0, 3) eq "\e[H")
                     {
                       while (length($geno) > 70)
                       {
                         print "\e[H" . substr($geno, 0, 70, '') . "--More--\e[K";
                         ReadKey(0);
                       }
                       $geno
                     }
                     else
                     {
                       if (length($geno) >= 30)
                       {
                         substr($geno, 0, 30) . "..."
                       }
                       else
                       {
                         $geno
                       }
                     }
                 };
each_iteration
{
  while (/Wiped out all (.*?)\./g)
  {
    $geno{$1} = 1;
  }
}

