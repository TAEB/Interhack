# improves exp display to show how much more for next level
# also adds an extended command #exp for a summary
# by Eidolos with help from arcanehl

my @exp_for = qw/0 0 20 40 80 160 320 640 1280 2560 5120 10000 20000 40000
80000 160000 320000 640000 1280000 2560000 5120000 10000000 20000000 30000000
40000000 50000000 60000000 70000000 80000000 90000000 10000000/;

sub exp_for
{
  my $level = shift;
  return 0 if $level < 1 || $level > 30;
  return $exp_for[$level];
}

our ($level, $total_exp, $exp_needed);

extended_command "#exp"
              => sub
                 {
                   return "Level: 30. Experience: $total_exp."
                     if $level == 30;

                   sprintf 'Level: %d. Experience: %d. '
                         . 'Next in: %d. Progress: %.2f%%.',
                             $level,
                             $total_exp,
                             $exp_needed,
                             100 * ($total_exp        - exp_for($level))
                                 / (exp_for($level+1) - exp_for($level))
                 };

each_iteration
{
  s{Xp:(\d+)\/(\d+)}{
    ($level, $total_exp) = ($1, $2);
    my $length = length $total_exp;
    $exp_needed = exp_for($level+1) - $total_exp;
    $exp_needed = 0 if $level == 30;

    if (length($exp_needed)-1 > $length)
    {
      "Xp:$level!$total_exp"
    }
    else
    {
      sprintf "X:%dn%-" . (1+$length) . "s", $level, $exp_needed
    }
  }eg;
};

