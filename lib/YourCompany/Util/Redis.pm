package YourCompany::Util::Redis;

use YourCompany::Perl::UTF8;

use Exporter qw( import );

use YourCompany::Config;

BEGIN { # Parent is Redis::Fast; otherwise Redis.
    require parent;
    eval {
        require Redis::Fast;
        parent->import( 'Redis::Fast' );
        1;
    } or do {
        require Redis;
        parent->import( 'Redis' );
    };
}

our @EXPORT_OK;

sub new_r {
    my ( $class, $key ) = @_;

    my $settings = YourCompany::Config->redis->{$key};

    return sub {
        state $instance = $class->new(
            server     => "$settings->{host}:$settings->{port}",
            reconnect  => $settings->{reconnect} // 1,
            on_connect => sub {
                my $self = shift;
                $self->select( $settings->{index} )  if $settings->{index} != 0;
                $self;
            },
        );
        $instance;
    };
}

BEGIN {
    my $config = eval { YourCompany::Config->redis } // {};
    my $class  = __PACKAGE__;

    @EXPORT_OK = ();

    no strict 'refs'; ## no critic (TestingAndDebugging::ProhibitNoStrict)
    for my $key ( keys %$config ) {
        *{"$class\::$key"} = *{"$class\::r_$key"} = $class->new_r( $key );
        push @EXPORT_OK, "&r_$key";
    }
    use strict 'refs';
}

1;
