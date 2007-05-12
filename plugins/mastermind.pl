# solve that drawbridge mastermind in style!
# adds #mm to reset mastermind state
# by Eidolos

my $mastermind_prog = "./c/automastermind";
my $responses_so_far = "";
my $response_this_play = 0;

extended_command "#mm"
              => sub { ($responses_so_far, $response_this_play) = ('', 0);
                       "Resetting Mastermind status." };

each_iteration
{
  if (/\e\[HYou hear (\d) tumblers? click and (\d) gears? turn\./)
  {
    $responses_so_far .= " $2$1";
    $response_this_play = 1;
  }
  elsif (/\e\[HYou hear (\d) tumblers? click\./)
  {
    $responses_so_far .= " 0$1";
    $response_this_play = 1;
  }
  elsif (/\e\[HYou hear (\d) gears? turn\./)
  {
    $responses_so_far .= " ${1}0";
    $response_this_play = 1;
  }
  elsif (/\e\[HWhat tune are you playing\?/)
  {
    $responses_so_far .= " 00" unless $response_this_play;
    $response_this_play = 0;

    my $next = `$mastermind_prog $responses_so_far`;
    if ($next =~ /ACK/)
    {
      ($responses_so_far, $response_this_play) = ('', 1);
      annotate("No possible tunes. Resetting.");
    }
    else
    {
      ($next) = $next =~ /^([A-G]{5})/;
      tab("$next\n");
    }
  }
}

