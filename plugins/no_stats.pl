# avoids adding stats to botl to make room for other more important things
# stats are still available through new #stats ext-cmd
# by Eidolos

my $stats = '';

extended_command "#stats"
              => sub { $stats };

each_iteration
{
  s{\e\[23;1H((.*?)\s*(St:\d+.*?Ch:\d+)\s+(\w+)\s+S:)(\d+)}{
    $score_pos = length $1;
    ($char, $stats, $align, $score) = ($2, $3, $4, $5);
    "\e[23;1HS:$score\e[K"
  }eg;
  s{\e\[23;(?!1H)(\d+)H(\d+)}{
    my ($update_pos, $score_update) = ($1, $2);
    my $same_length = $update_pos - $score_pos - 1;
    substr($score, $same_length, length($score_update), $score_update);
    "\e[23;1HS:$score\e[K"
  }eg;
}

