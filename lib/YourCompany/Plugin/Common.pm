package YourCompany::Plugin::Common;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_BAD_REQUEST HTTP_INTERNAL_SERVER_ERROR );
use Scalar::Util qw( blessed );

use Mojo::Base 'Mojolicious::Plugin';

use YourCompany::Plack::Error;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( 'reply.exception' => sub {
        my ( $c, $exception ) = @_;

        if ( blessed($exception) && $exception->isa( 'YourCompany::Plack::Error' ) ) {
            return $c->render( $exception->to_render )
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
