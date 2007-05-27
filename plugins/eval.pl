# adds an extended command #eval for evaluating Perl code
# I don't think this has any security holes, but one can never be too sure
# this requires that you set $load_eval to 1 before including *, just so you
# know what you're dealing with

# this can be useful because it's so damn flexible.. for example, re-remapping
# keys: #eval $keymap{"\ce"} = "EE  Elbereth\n"

# set a reminder: #eval press_tab sub{$vt->row_text(24)=~/^Dlvl:9\b/}=>"enchant stuff plz"
# by Eidolos

if ($load_eval)
{
    use Devel::EvalContext; # for persistency across #evals
    extended_command "#eval"
                  => sub
                  {
                      my ($command, $args) = @_;
                      return "Syntax: #eval CODE" if !defined($args) || $args eq '';
                      my $ret = eval $args;
                      return "undef" if !defined($ret);
                      return $ret;
                  }
}

