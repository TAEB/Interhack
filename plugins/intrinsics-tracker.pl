our %intrinsics;

sub show_intrinsics
{
    my $annotation = "Intrinsics: " . join(', ', sort keys %intrinsics);
    pline($annotation);
}

extended_command "#intrinsics" => \&show_intrinsics;
extended_command "#int" => \&show_intrinsics;

# add_intrinsic and del_intrinsic return 0 if no change was made, 1 if there was
# this way you can avoid reminding the player he "still" has poison resistance

sub add_intrinsic
{
    my $intrinsic = shift;
    return 0 if $intrinsics{$intrinsic};
    $intrinsics{$intrinsic} = 1;
    return 1;
}

sub del_intrinsic
{
    my $intrinsic = shift;
    return 0 if $intrinsics{$intrinsic};
    delete $intrinsics{$intrinsic};
    return 1;
}
