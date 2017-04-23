use YourCompany::Test::UTF8;

use HTTP::Status qw( HTTP_INTERNAL_SERVER_ERROR HTTP_NOT_FOUND );

describe "YourCompany::Plack::Error" => sub {
    before all => sub {
        use_ok "YourCompany::Plack::Error";
    };

    describe new => sub {
        it "should create HTTP_INTERNAL_SERVER_ERROR with no messages by default" => sub {
            my $err = YourCompany::Plack::Error->new;
            is $err->code, HTTP_INTERNAL_SERVER_ERROR;
            is $err->message, "";
            is_deeply $err->messages, [];
        };

        it "should create HTTP_INTERNAL_SERVER_ERROR with received messages" => sub {
            my $err = YourCompany::Plack::Error->new(
                messages => [ "Yo", "man" ],
            );
            is $err->code, HTTP_INTERNAL_SERVER_ERROR;
            is $err->message, "Yo\nman";
            is_deeply $err->messages, [ "Yo", "man" ];
        };
    };

    describe instance => sub {
        my $instance = undef;

        before each => sub {
            $instance = YourCompany::Plack::Error->new(
                messages => [ qw( oh my god ) ],
            );
        };

        describe TO_JSON => sub {
            it worked => sub {
                is $instance->TO_JSON->{status}, HTTP_INTERNAL_SERVER_ERROR;
                is_deeply $instance->TO_JSON->{errors}, [ qw( oh my god ) ];
            };
        };

        describe as_string => sub {
            it worked => sub {
                like $instance->as_string, qr/\bgod\b/;
            };
        };

        describe to_render => sub {
            it worked => sub {
                my %render_data = $instance->to_render;
                is_deeply \%render_data, {
                    status => HTTP_INTERNAL_SERVER_ERROR,
                    json   => {
                        success => \0,
                        status  => HTTP_INTERNAL_SERVER_ERROR,
                        errors  => [ qw( oh my god ) ],
                    },
                };
            }
        };
    };

    describe throw => sub {
        it "dies with received Error object" => sub {
            my $err = YourCompany::Plack::Error->new;
            throws_ok {
                YourCompany::Plack::Error->throw($err);
            } "YourCompany::Plack::Error", "";
            is $@, $err;
        };

        it "dies with received code and messages" => sub {
            throws_ok {
                YourCompany::Plack::Error->throw(HTTP_NOT_FOUND, "1", "2");
            } "YourCompany::Plack::Error", "";
            my $err = $@;
            is $err->code, HTTP_NOT_FOUND;
            is_deeply $err->messages, [ "1", "2" ];
        };

        it "dies with received message" => sub {
            throws_ok {
                YourCompany::Plack::Error->throw("1");
            } "YourCompany::Plack::Error", "";
            my $err = $@;
            is $err->code, HTTP_INTERNAL_SERVER_ERROR;
            is_deeply $err->messages, [ "1" ];
        };
    };


    describe not_found => sub {
        my $err;

        it "dies" => sub {
            throws_ok {
                YourCompany::Plack::Error->not_found("wow");
            } "YourCompany::Plack::Error", "";
            $err = $@;
        };

        it "with HTTP_NOT_FOUND code" => sub {
            is $err->code, HTTP_NOT_FOUND;
        };

        it "and expected message" => sub {
            is $err->message, "wow";
        };
    };
};

runtests  unless caller;
