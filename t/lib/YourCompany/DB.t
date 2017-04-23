use YourCompany::Test::UTF8;

describe "YourCompany::DB" => sub {
    before all => sub {
        use_ok "YourCompany::DB";
    };

    describe txn_do => sub {
        it "should run code block" => sub {
            my $called = 0;
            YourCompany::DB->txn_do(sub {
                $called = 1;
            });
            is $called, 1;
        };

        it "with passed parameters" => sub {
            my @param = ();
            YourCompany::DB->txn_do(sub {
                @param = @_;
            }, 'a', 2 );
            is_deeply \@param, [ 'a', 2 ];
        };
    };
};

runtests  unless caller;
