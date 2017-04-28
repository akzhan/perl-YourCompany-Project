package YourCompany::Config;

use YourCompany::Perl::UTF8;

use Cwd qw( abs_path );
use File::Basename qw( dirname );
use Hash::Merge qw( merge );
use YAML::Syck qw( LoadFile );

sub _loader {
    local $YAML::Syck::ImplicitTyping  = 1;
    local $YAML::Syck::ImplicitUnicode = 1;

    my $BASE_DIR = abs_path( dirname( __FILE__ ). "/../.." );

    my $defaults = LoadFile( "$BASE_DIR/config/defaults.yml" );
    my $local    = LoadFile( "$BASE_DIR/config/local.yml" );

    Hash::Merge::set_behavior( 'RIGHT_PRECEDENT' );

    my $config = merge( $defaults, $local );

    # per process setup

    return $config;
}

BEGIN {
    my $class = __PACKAGE__;

    my $config = $class->_loader();

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
}

1;
