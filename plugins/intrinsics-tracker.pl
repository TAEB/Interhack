our %intrinsics;

extended_command "#intrinsics"
    => sub
    {
        my $annotation;
        for my $key (keys %intrinsics)
        {
           $annotation .= "$key ";
        }
        annotate($annotation)
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
