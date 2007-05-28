# solve that drawbridge mastermind in style!
# adds #mm to reset mastermind state
# by Eidolos

our $mastermind_prog = "./c/automastermind";
our $responses_so_far = "";
our $response_this_play = 1;

extended_command "#mm"
              => sub { ($responses_so_far, $response_this_play) = ('', 1);
                       "Resetting Mastermind status." };

each_match_vt 1, qr/You hear (\d) tumblers? click and (\d) gears? turn\./
    => sub
       {
           $responses_so_far .= " $2$1";
           $response_this_play = 1;
       };
each_match_vt 1, qr/You hear (\d) tumblers? click\./
    => sub
       {
           $responses_so_far .= " 0$1";
           $response_this_play = 1;
       };
each_match_vt 1, qr/You hear (\d) gears? turn\./
    => sub
       {
           $responses_so_far .= " ${1}0";
           $response_this_play = 1;
       };
each_match_vt 1, qr/What tune are you playing\?/
    => sub
       {
           $responses_so_far .= " 00" unless $response_this_play;
           $response_this_play = 0;

           my $next = `$mastermind_prog $responses_so_far`;
           if ($next =~ /ACK/)
           {
               ($responses_so_far, $response_this_play) = ('', 1);
               annotate("No possible tunes. Resetting. Press tab for AABBC\\n.");
               $tab = "AABBC\n";
           }
           else
           {
               ($next) = $next =~ /^([A-G]{5})/;
               tab("$next\n");
           }
       };

