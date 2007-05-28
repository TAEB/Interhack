# adds a game clock to the right side of the penultimate line
# also adds an extended command #time
# by Eidolos

our $start_time = time;
our $time = 0;

extended_command "#time" => sub { $time };

each_iteration
{
    $time = time - $start_time;
    $botl{time} = serialize_time($time);
}

