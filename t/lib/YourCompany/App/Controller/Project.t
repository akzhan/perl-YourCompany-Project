use YourCompany::Test::UTF8;

use Mojolicious;
use Mojo::JSON qw( decode_json );
use Test::Mojo;
use HTTP::Status qw( HTTP_OK );

use YourCompany::App;
use YourCompany::Plack::Error;

describe "YourCompany::App::Controller::Project" => sub {
    my ( $t );

    before all => sub {
        use_ok "YourCompany::App::Controller::Project";
    };

    before each => sub {
        $t = Test::Mojo->new('YourCompany::App');
    };

    describe "list" => sub {
        it "should render json" => sub {
            $t->get_ok('/projects')
                ->status_is(HTTP_OK)
                ->json_is("/status", HTTP_OK)
                ->json_is("/success", Mojo::JSON::true)
                ->json_has("/model")
                ;
        };
    };
};

runtests  unless caller;
