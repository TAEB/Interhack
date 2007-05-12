# this is broken up so we can programmatically color truncated forms of stats
# consider a really long botl that ends with "Ill Burde" - clearly that's
# Burdened but we can't display it, but we should color it
# the cutoff is three characters so as to minimize false positives

# pre-code {{{
my %status_colors =
(
# }}}

# hunger {{{
"Satiated" => "red",
"Hungry"   => "red",
"Weak"     => "bred",
"Fainting" => "bred",
"Fainted"  => "bred",
# }}}

# minor status effects {{{
"Stun"  => "bgreen",
"Conf"  => "bgreen",
"Hallu" => "bgreen",
# }}}

# major status effects {{{
"Ill"      => "bred",
"FoodPois" => "bred",
# }}}

# burden level {{{
"Burdened"   => "yellow",
"Stressed"   => "red",
"Strained"   => "bred",
"Overtaxed"  => "bred",
"Overloaded" => "bred",
# }}}

# post-code {{{
);

while (my ($k, $v) = each(%status_colors))
{
  for (3..length($k))
  {
    my $status_trunc = substr($k, 0, $_);
    recolor qr/(?<= )$status_trunc(?=[ \e])/ => $v;
  }
}

# }}}

