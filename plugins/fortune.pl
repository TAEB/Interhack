# adds a fortune to the login screen
# by Eidolos

my $fortune = "$ENV{HOME}/.fortune/nethackidiocy";

each_iteration
{
    if ($at_login)
    {
        $postprint .= "\e[s\e[19H\e[1;30m"
                    . `fortune $fortune`
                    . "\e[0m\e[u"
    }
}

