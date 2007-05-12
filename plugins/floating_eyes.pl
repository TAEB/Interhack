# make floating eyes bright cyan
# by Eidolos

# known issues: also colors shocking spheres bright cyan

each_iteration
{
    s{
        \e\[          # escape code initiation
        (?:0;)? 34m   # look for dark blue of floating eyes
        ((?:\x0f)? e) # look for e with or without DEC sequence
        (?! - )       # avoid false positive with menucolors
    }
    {\e[1;36m$1}xg;
}

