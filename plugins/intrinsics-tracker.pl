our %intrinsics;

extended_command "#intrinsics"
    => sub
    {
        my $annotation = "Intrinsics: " . join(', ', sort keys %intrinsics);
        pline($annotation);
    };

sub add_intrinsic
{
    my $intrinsic = shift;
    $intrinsics{$intrinsic} = 1;
}

sub del_intrinsic
{
    my $intrinsic = shift;
    delete $intrinsics{$intrinsic};
}
