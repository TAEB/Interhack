our %intrinsics;

sub show_intrinsics
{
    my $annotation = "Intrinsics: " . join(', ', sort keys %intrinsics);
    pline($annotation);
}

extended_command "#intrinsics" => \&show_intrinsics;
extended_command "#int" => \&show_intrinsics;

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
