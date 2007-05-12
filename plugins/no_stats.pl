# avoids adding stats to botl to make room for other more important things
# stats are still available through new #stats ext-cmd
# by Eidolos and doy

our $stats = '';
my $char = '';
my @stats = ();
my $align = '';
my $score = '';
my @stat_pos = ();
my $score_pos = '';

extended_command "#stats"
              => sub { $stats };

each_iteration
{
  my $s = qr/(?:\s|\e\[C)/;
  my $st_char = qr#[\d\*/]#;
  s{\e\[23;(\d+)H((.*?)$s*)(St:($st_char+) Dx:(\d+) Co:(\d+) In:(\d+) Wi:(\d+) Ch:(\d+))($s+(\w+)$s+)S:(\d+)}{
    my $stat_start = length($2) + $1 - 1;
    $char = $3;
    $stats = $4;
    @stats = ($5, $6, $7, $8, $9, ${10});
    $stat_pos[0] = $stat_start + 3;
    for my $i (1..5) {
      $stat_pos[$i] = $stat_pos[$i - 1] + length($stats[$i - 1]) + 4;
    }
    $score_pos = $stat_start + length($stats) + length(${11}) + 2;
    $align = ${12};
    $score = ${13};
    "\e[23;1HS:$score\e[K"
  }eg;

  s{\e\[23;(?!1H)(\d+)H($st_char+)}{
    my ($update_pos, $update) = ($1, $2);
    for my $i (0..4) {
      if ($update_pos >= $stat_pos[$i] && $update_pos < $stat_pos[$i + 1]) {
        my $same_length = $update_pos - $stat_pos[$i] - 1;
        substr($stats[$i], $same_length, length($update), $update);
      }
    }
    if ($update_pos >= $stat_pos[5] && $update_pos < $score_pos) {
      my $same_length = $update_pos - $stat_pos[5] - 1;
      substr($stats[5], $same_length, length($update), $update);
    }
    elsif ($update_pos >= $score_pos) {
      my $same_length = $update_pos - $score_pos - 1;
      substr($score, $same_length, length($update), $update);
    }
    $stats = "St:$stats[0] Dx:$stats[1] Co:$stats[2] In:$stats[3] Wi:$stats[4] Ch:$stats[5]";
    "\e[23;1HS:$score\e[K"
  }eg;
}

