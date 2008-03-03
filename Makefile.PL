# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name 'Interhack';
version '1.0';

requires 'IO::Socket';
requires 'Term::ReadKey';
requires 'LWP::Simple';
requires 'File::Temp';
requires 'Term::VT102';
requires 'Time::HiRes';

features(
    'nhgrep' => [
        -default => 0,
       requires('Term::TtyRec::Plus'),
    ],
    'IH server (devnull support)' => [
        -default => 0,
        requires('IO::Pty::Easy'),
        requires('IO::Socket::INET'),
    ],
    'Hiveminder plugin (I think it is broken)' => [
        -default => 0,
        requires('Net::OSCAR'),
    ],
);

auto_install;
WriteAll;

