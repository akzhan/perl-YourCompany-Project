use YourCompany::Test::UTF8;

{
    package Plack::AsStringError;

    use Mojo::Base -base;

    use HTTP::Status qw( HTTP_BAD_REQUEST );

    sub code { HTTP_BAD_REQUEST }

    sub as_string { "an err" }
}

{
    package Plack::GenericError;

    use Mojo::Base -base;

    use HTTP::Status qw( HTTP_NOT_FOUND );

    use overload '""' => sub { "an err" };

    sub code { HTTP_NOT_FOUND }
}

use HTTP::Status qw( HTTP_INTERNAL_SERVER_ERROR HTTP_NOT_FOUND HTTP_BAD_REQUEST );
use Mojolicious;
use Mojo::JSON qw( decode_json );
use Test::Mojo;

use YourCompany::Plack::Error;

describe "YourCompany::Plugin::Common" => sub {
    my ( $t, $c );

    before all => sub {
        use_ok "YourCompany::Plugin::Common";
    };

    before each => sub {
        $t = Test::Mojo->new;
        $t->app(Mojolicious->new);
        $t->app->plugin( "YourCompany::Plugin::Common" );
        $c = $t->app->build_controller;
    };

    describe "reply.exception" => sub {
        it "renders json with error on our plack error" => sub {
            $c->reply->exception( YourCompany::Plack::Error->new( code => HTTP_NOT_FOUND, messages => ["err"] ) );
            my $json = decode_json( $c->res->body );
            is_deeply $json, {
                errors  => [ 'err' ],
                status  => HTTP_NOT_FOUND,
                success => \0,
            };
            is $c->res->code, HTTP_NOT_FOUND;
        };

        it "renders json with error on as string plack error" => sub {
            $c->reply->exception( Plack::AsStringError->new );
            is $c->res->body, "an err";
            is $c->res->code, HTTP_BAD_REQUEST;
        };


        it "renders json with error on stringified plack error" => sub {
            $c->reply->exception( Plack::GenericError->new );
            is $c->res->body, "an err";
            is $c->res->code, HTTP_NOT_FOUND;
        };

        it "renders json with internal server error on another die" => sub {
            $c->reply->exception( "hm" );
            my $json = decode_json( $c->res->body );
            is_deeply $json, {
                errors  => [ 'hm' ],
                status  => HTTP_INTERNAL_SERVER_ERROR,
                success => \0,
            };
            is $c->res->code, HTTP_INTERNAL_SERVER_ERROR;
        };
    };
};

runtests  unless caller;
