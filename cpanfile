requires "perl" => 5.020_002;

requires "Cwd";
requires "Data::Dump";
requires "JSON::XS";
requires "Hash::Merge";
requires "HTTP::Status";
requires "File::Basename";
requires "File::Spec";
requires "File::Find";
requires "File::Slurper";
requires "List::Util" => "1.33";
requires "Readonly";
requires "Scalar::Util";
requires "YAML::Syck";
requires "constant";
requires "lib::abs" => "0.93";
requires "mro";

# Redis just for example of use YourCompany::Util::Redis
requires "Redis::Fast" => "0.20";

# Postgres!
requires "DBD::Pg";
requires "DBIx::Class";
requires "App::Sqitch" => "0.9994";

# Mojo based Perl project
requires "Mojolicious" => "7.31";
requires "Mojolicious::Plugin::Model";
requires "Mojolicious::Plugin::OpenAPI" => "1.13";
requires "Starman";

on test => sub {
    requires "Test::More";
    requires "Test::Exception" => "0.43";
    requires "Test::Spec";
    requires "Data::Fake";
};

on develop => sub {
    requires "Devel::Cover";
    requires "Devel::REPL";
    requires "Devel::NYTProf";
    requires "Perl::Critic";
    requires "Perl::Tidy";
    requires "Term::ANSIColor"; # Colored prove
    requires "Term::ReadLine::Perl"; # REPL
};
