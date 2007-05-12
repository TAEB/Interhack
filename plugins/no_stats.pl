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

  s{\e\[23;(?!1H)(\d+)H((?:$st_char|\e\[C)+)(\e\[K)?}{
    my $update_pos = $1;
    my @updates = split /\e\[C/, $2;
    my $clr_to_end = $3;
    for my $i (0..4) {
      if ($update_pos >= $stat_pos[$i] && $update_pos < $stat_pos[$i + 1]) {
        for my $update (@updates) {
          my $start = $update_pos - $stat_pos[$i] - 1;
          substr($stats[$i], $start, length($update), $update);
          $update_pos += length($update) + 1;
        }
        $update_pos--;
        $stats[$i] = substr($stats[$i], 0, $update_pos - $stat_pos[$i] - 1)
          if $clr_to_end;
      }
    }
    if ($update_pos >= $stat_pos[5] && $update_pos < $score_pos) {
      for my $update (@updates) {
        my $start = $update_pos - $stat_pos[5] - 1;
        substr($stats[5], $start, length($update), $update);
        $update_pos += length($update) + 1;
      }
      $update_pos--;
      $stats[5] = substr($stats[5], 0, $update_pos - $stat_pos[5] - 1)
        if $clr_to_end;
    }
    elsif ($update_pos >= $score_pos) {
      for my $update (@updates) {
        my $start = $update_pos - $score_pos - 1;
        substr($score, $start, length($update), $update);
        $update_pos += length($update) + 1;
      }
      $update_pos--;
      $score = substr($score, 0, $update_pos - $score_pos - 1)
        if $clr_to_end;
    }
    $stats = "St:$stats[0] Dx:$stats[1] Co:$stats[2] In:$stats[3] Wi:$stats[4] Ch:$stats[5]";
    "\e[23;1HS:$score\e[K"
  }eg;
}

