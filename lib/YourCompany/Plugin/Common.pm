package YourCompany::Plugin::Common;

=encoding utf-8

=head1 NAME

YourCompany::Plugin::Common

=head1 DESCRIPTION

This plugin provides L<Mojolicious> hooks to allow common JSON API's behavior.

=head1 SYNOPSYS

    package MyApp;

    use Mojo::Base qw( Mojolicious );

    # This method will run once at server start
    sub startup {
        my $self = shift;

        $self->plugin('YourCompany::Plugin::Common');
    }

    # ...and somewhere

    use YourCompany::Plack::Error;

    YourCompany::Plack::Error->bad_request( "Bad args!" );

=head1 SEE ALSO

=over

=item * L<YourCompany::Plack::Error>.

=back

=cut

use Mojo::Base 'Mojolicious::Plugin';
use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_INTERNAL_SERVER_ERROR );
use Scalar::Util qw( blessed );

use YourCompany::Config;
use YourCompany::Plack::Error;

sub register( $self, $app, @args ) {
    $app->defaults( config => YourCompany::Config->all );
    $app->config( YourCompany::Config->all );

    # Exception handling
    $app->helper( 'reply.exception' => sub {
        my ( $c, $exception ) = @_;

        # just log error
        $app->log->error( "$exception" );

        if ( blessed($exception) ) {
            if ( $exception->isa( 'YourCompany::Plack::Error' ) ) {
                return $c->render( $exception->to_render );
            }

            if ( $exception->can("as_psgi") || $exception->can("code") ) {
                # delegate handling up to middleware
                die $exception; ## no critic (ErrorHandling::RequireCarping)
            }
        }

        return $c->render( status => HTTP_INTERNAL_SERVER_ERROR, json => {
            success => \0,
            status  => HTTP_INTERNAL_SERVER_ERROR,
            errors  => [ "$exception" ],
        });
    } );

    # ALLOW CORS
    $app->hook( after_render => sub {
        my ( $c, $output, $format ) = @_;

        $c->res->headers->header( 'Access-Control-Allow-Origin' => '*' );
        $c->res->headers->header( 'Access-Control-Allow-Credentials' => 'true' );
        $c->res->headers->header( 'Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT' );
        $c->res->headers->header( 'Access-Control-Allow-Headers' => 'Content-Type' );
        $c->res->headers->header( 'Access-Control-Max-Age' => '1728000' );
    } );
}

1;
