package YourCompany::Config;

=encoding utf-8

=head1 NAME

YourCompany::Config

=head1 DESCRIPTION

YourCompany Project configuration based on C<YAML> format.

It reads I<config/defaults.yml> and overrides settings with I<config/MODE.yml> and I<config/local.yml>
where C<MODE> is equal to I<$ENV{MOJO_MODE}>, I<$ENV{PLACK_ENV}> or I<"development">.

All root sections available through C<YourCompany::Config-E<gt>$section> property accessor.

Root available as C<YourCompany::Config-E<gt>all>.

=head1 SYNOPSYS

    use YourCompany::Config;

    say YourCompany::Config->database->{name};

=cut

use YourCompany::Perl::UTF8;

use Cwd qw( abs_path );
use File::Basename qw( dirname );
use Hash::Merge ();
use YAML::Syck qw( LoadFile );

sub _loader( $, $mode ) {
    local $YAML::Syck::ImplicitTyping  = 1;
    local $YAML::Syck::ImplicitUnicode = 1;

    my $BASE_DIR = abs_path( dirname( __FILE__ ). "/../.." );

    my @files_to_merge = ( 'defaults' );
    push @files_to_merge, $mode  if $mode;
    push @files_to_merge, 'local';

    my $config = {
        app => {
            mode => $mode,
        },
    };
    my $merger = Hash::Merge->new( 'RIGHT_PRECEDENT' );
    for (@files_to_merge) {
        my $file_name = "$BASE_DIR/config/$_.yml";
        next  unless -r $file_name;
        my $to_merge = LoadFile( $file_name );

        $config = $merger->merge( $config, $to_merge );
    }

    # per process setup

    return $config;
}

sub _setup( $class ) {
    my $mode   = $ENV{MOJO_MODE} || $ENV{PLACK_ENV} || 'development';
    my $config = $class->_loader($mode);

    no strict 'refs'; ## no critic (TestingAndDebugging::ProhibitNoStrict)
    for my $key ( keys %$config ) {
        *{"$class\::$key"} = sub {
            $config->{$key};
        };
    }

    *{"$class\::all"} = sub {
        return $config;
    };
    use strict 'refs';

    return $config;
}

sub import( $class, @ ) {
    state $did_setup = 0;
    unless ( $did_setup ) {
        $did_setup = 1;
        $class->_setup;
    }
}

1;
