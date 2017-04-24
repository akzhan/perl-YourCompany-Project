use YourCompany::Test::UTF8;

use Mojolicious;
use Mojo::JSON qw( decode_json );
use Test::Mojo;
use HTTP::Status qw( HTTP_OK );

use YourCompany::App;
use YourCompany::Plack::Error;

my $t;

sub json {
    $t->tx->res->json;
}

describe "YourCompany::App::Api::Project" => sub {
    describe "list" => sub {
        before all => sub {
            $t = Test::Mojo->new('YourCompany::App');
        };

        it "should render json" => sub {
            $t->get_ok('/api/projects')
                ->status_is(HTTP_OK)
                ->json_is("/status", HTTP_OK)
                ->json_is("/success", Mojo::JSON::true)
                ->json_has("/model")
                ;
        };

        it "has array as model" => sub {
            isa_ok json->{model}, 'ARRAY';
        };
    };
};

runtests  unless caller;
