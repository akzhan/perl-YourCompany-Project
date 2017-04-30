use YourCompany::Test::UTF8;

describe "YourCompany::Config" => sub {
    before all => sub {
        use_ok "YourCompany::Config";
    };

    describe all => sub {
        it "should be hashref to config" => sub {
            isa_ok YourCompany::Config->all, 'HASH';
        }
    };

    describe defaults => sub {
        it "loaded" => sub {
            ok( YourCompany::Config->defaults->{loaded} );
        };
    };
};

runtests  unless caller;
