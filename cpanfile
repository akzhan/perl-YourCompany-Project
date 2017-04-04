requires "perl" => 5.020_003;

requires "Data::Dump";
requires "File::Basename";
requires "File::Spec";
requires "File::Find";
requires "File::Slurper";
requires "List::Util" => "1.33";
requires "lib::abs" => "0.93";

on test => sub {
    requires "Test::More";
    requires "Test::Exception";
    requires "Test::Spec";
};

on develop => sub {
    requires "Devel::REPL";
    requires "Devel::NYTProf";
    requires "Perl::Critic";
    requires "Perl::Tidy";
    requires "Term::ANSIColor"; # Colored prove
    requires "Term::ReadLine::Perl"; # REPL
};
