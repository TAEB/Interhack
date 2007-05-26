# add extended-commands #write and #notes (need better names.. don't want to use
# #note and #notes)
# by Eidolos

our $note_file ||= 'notes.txt';
sub open_notes
{
    my $rw = shift || '>>';
    open my $h, $rw, $note_file
        or warn "Unable to open $note_file for ${rw}ing: $!";
    return $h;
}

my $note_handle = open_notes('>>');

sub make_note
{
    print {$note_handle} map {"T:$turncount $_\n"} @_;
}

extended_command "#write"
              => sub
                 {
                     my (undef, $args) = @_;
                     if (!defined($args))
                     {
                        return "Syntax: #write [note]";
                     }
                     make_note $args;
                     return "Noted!";
                 };

extended_command "#notes"
              => sub
                 {
                     close $note_handle;

                     $ENV{EDITOR} = 'vi' unless exists $ENV{EDITOR};
                     system("$ENV{EDITOR} $note_file");

                     $note_handle = open_notes('>>');
                     request_redraw();

                     return "Thank you sir, may I have another?";
                 };

