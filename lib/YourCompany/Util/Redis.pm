package YourCompany::Util::Redis;

=head1 NAME

YourCompany::Util::Redis

=head1 DESCRIPTION

L<Redis::Fast>/L<Redis> child class that configured through L<YourCompany::Config>.

It exports all known configurations like

    YourCompany::Util::Redis->config_key # it is singleton.

or

    use YourCompany::Util::Redis qw( r_config_key ); # r_config_key() is singleton

=head1 SYNOPSYS

Define Redis config:

    redis:
      default:
        host: localhost
        port: 6379
        index: 777
        reconnect: 1

And now use

    use YourCompany::Util::Redis qw( r_default );

    r_default->get( "key" );

    YourCompany::Util::Redis->default->set( "key", "value" );

    my $another_instance = YourCompany::Util::Redis->new_r( "default" );
    my $other_instance   = YourCompany::Util::Redis->new( config );

=cut

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

=head1 METHODS

=head2 new_r

    YourCompany::Util::Redis->new_r( "default" );

Creates new Redis client instance based on specified redis configuration.

=cut

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

our @EXPORT_OK;

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
