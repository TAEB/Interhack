# adds an automore feature to bypass those pesky --More-- prompts
# mostly for the end of the game where you're buff enough to take anything out
# waits for a small amount of time before spacing them off just so you can
# kinda glance at them, might need to be made shorter
# enable/disable with #automore (off by default for obvious reasons)
# by Eidolos

our $automore_enabled = 0;
our $automore_delay = 0.05;

extended_command "#automore"
              => sub
                 {
                   # the "if" is to guard against ^P toggling
                   $automore_enabled = not $automore_enabled;
                   "Automore " . ($automore_enabled ? "ON." : "OFF.")
                 };

each_match qr/--More--/ => sub
{
    return unless $automore_enabled;
    my $top_row = $vt->row_text(1);
    return if $top_row =~ /Message History/ || $top_row =~ /Things that are here/;
    select undef, undef, undef, $automore_delay;
    print_sock ' ';
}

