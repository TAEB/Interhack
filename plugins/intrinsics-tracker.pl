our %intrinsics;

extended_command "#intrinsics"
    => sub
    {
        my $annotation;
        for my $key (keys %intrinsics)
        {
           $annotation .= "$key " if exists($intrinsics{$key});
        }
        annotate($annotation)
    };

sub add_intrinsic
{
    my $intrinsic = shift;
    $intrinsics{$intrinsic} = 1 if !exists($intrinsics{$intrinsic});
}

sub del_intrinsic
{
    my $intrinsic = shift;
    $intrinsics{$intrinsic} = 0 if $intrinsics{$intrinsic};
}
