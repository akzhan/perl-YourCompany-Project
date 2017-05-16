use YourCompany::Test::UTF8;

{
    package Plack::AnotherError;

    use Mojo::Base -base;

    use HTTP::Status qw( HTTP_NOT_FOUND );

    use overload '""' => sub { "an err" };

    sub code { HTTP_NOT_FOUND }
}

use Mojolicious;
use Mojo::JSON qw( decode_json false );
use Test::Mojo;
use HTTP::Status qw( HTTP_NOT_FOUND HTTP_INTERNAL_SERVER_ERROR );

use YourCompany::Plack::Error;

describe "YourCompany::App::Plugin::Common" => sub {
    my ( $t, $c );

    before all => sub {
        use_ok "YourCompany::App::Plugin::Common";
    };

    before each => sub {
        $t = Test::Mojo->new;
        $t->app(Mojolicious->new);
        $t->app->plugin( "YourCompany::App::Plugin::Common" );
        $c = $t->app->build_controller;
    };

    describe "app.defaults" => sub {
        they "should be loaded" => sub {
            ok $t->app->defaults('config')->{defaults}{loaded};
        };
    };

    describe "app.config" => sub {
        it "should be loaded" => sub {
            ok $t->app->config->{defaults}{loaded};
        };
    };

    describe "reply.exception" => sub {
        it "should render json with error on our plack error" => sub {
            $c->reply->exception( YourCompany::Plack::Error->new( code => HTTP_NOT_FOUND, messages => ["err"] ) );
            my $json = decode_json( $c->res->body );
            is_deeply $json, {
                errors  => [ 'err' ],
                status  => HTTP_NOT_FOUND,
                success => false,
            };
            is $c->res->code, HTTP_NOT_FOUND;
        };

        it "should rethrow on Plack::Middleware::HTTPExceptions friendly error" => sub {
            throws_ok {
                $c->reply->exception( Plack::AnotherError->new );
            } "Plack::AnotherError";
        };

        it "should render json with internal server error on generic error" => sub {
            $c->reply->exception( "hm" );
            my $json = decode_json( $c->res->body );
            is_deeply $json, {
                errors  => [ 'hm' ],
                status  => HTTP_INTERNAL_SERVER_ERROR,
                success => false,
            };
            is $c->res->code, HTTP_INTERNAL_SERVER_ERROR;
        };
    };
};

runtests  unless caller;
