use YourCompany::Test::UTF8;

use Mojolicious;
use Mojo::JSON qw( decode_json );
use Test::Mojo;
use HTTP::Status qw( HTTP_OK HTTP_NOT_FOUND HTTP_CREATED );
use Readonly;

use YourCompany::App;
use YourCompany::DB;
use YourCompany::Plack::Error;

Readonly my $WRONG_ID => 0;
Readonly my $ACCEPT_HEADERS => { Accept => 'application/json' };

my $t;

describe "YourCompany::App::Controller::Project" => sub {
    before all => sub {
        YourCompany::DB->txn_begin;
        YourCompany::DB->rs('Project')->search(undef)->delete;
    };

    after all => sub {
        YourCompany::DB->txn_rollback;
    };

    describe list => sub {
        before all => sub {
            $t = Test::Mojo->new('YourCompany::App');
        };

        it "should render empty list" => sub {
            $t->get_ok('/projects', $ACCEPT_HEADERS)
                ->status_is(HTTP_OK)
                ->json_is("/status", HTTP_OK)
                ->json_is("/success", Mojo::JSON::true)
                ->json_is("/model", [])
                ;
        };
    };

    describe single => sub {
        before all => sub {
            $t = Test::Mojo->new('YourCompany::App');
        };

        it "should render not_found on wrong id" => sub {
            $t->get_ok("/projects/$WRONG_ID" => $ACCEPT_HEADERS)
                ->status_is(HTTP_NOT_FOUND)
                ->json_is("/status", HTTP_NOT_FOUND)
                ->json_is("/success", Mojo::JSON::false)
                ->json_has("/errors")
                ->json_hasnt("/model")
                ;
        };
    };

    context "project lifecycle" => sub {
        my $new_title;
        my $new_id;

        before all => sub {
            $t = Test::Mojo->new('YourCompany::App');
            $new_title = join "", grep { $_ gt  ' ' } map { chr rand(127) } (0..80);
        };

        describe post => sub {
            it "should create project with unique title" => sub {
                $t->post_ok("/projects" => $ACCEPT_HEADERS => json => {
                    title => $new_title,
                })->status_is(HTTP_CREATED)
                    ->json_is("/status", HTTP_CREATED)
                    ->json_is("/success", Mojo::JSON::true)
                    ->json_hasnt("/errors")
                    ->json_is("/model/title", $new_title)
                    ->json_like("/model/id", qr/^\d+$/)
                    ;
                $new_id = $t->tx->res->json("/model/id");
            };
        };

        describe "get created project" => sub {
            it "should render ok on created id" => sub {
                $t->get_ok("/projects/$new_id")
                    ->status_is(HTTP_OK)
                    ->json_is("/status", HTTP_OK)
                    ->json_is("/success", Mojo::JSON::true)
                    ->json_hasnt("/errors")
                    ->json_is("/model/id", $new_id)
                    ->json_is("/model/title", $new_title)
                    ;
            };
        };

        describe "delete existing project" => sub {
            it "should delete ok" => sub {
                $t->delete_ok("/projects/$new_id")
                    ->status_is(HTTP_OK)
                    ->json_is("/status", HTTP_OK)
                    ->json_is("/success", Mojo::JSON::true)
                    ->json_hasnt("/errors")
                    ->json_hasnt("/model")
                    ;
            };
        };

        describe "get project after delete" => sub {
            it "should render not_found on deleted id" => sub {
                $t->get_ok("/projects/$new_id")
                    ->status_is(HTTP_NOT_FOUND)
                    ->json_is("/status", HTTP_NOT_FOUND)
                    ->json_is("/success", Mojo::JSON::false)
                    ->json_has("/errors")
                    ->json_hasnt("/model")
                    ;
            };
        };
    };
};

runtests  unless caller;
