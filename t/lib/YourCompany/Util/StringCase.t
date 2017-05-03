use YourCompany::Test::UTF8;

describe "YourCompany::Util::StringCase" => sub {

    it 'should be used' => sub {
        use_ok "YourCompany::Util::StringCase", qw(
            camelize
            underscore
            dasherize
            humanize
            titleize
        );
    };

    describe underscore => sub {
        it "ActiveModel" => sub {
            is underscore('ActiveModel'), 'active_model';
        };

        it "ActiveModel" => sub {
            is underscore('ActiveModel::Errors'), 'active_model/errors';
        };

        it 'SSLError' => sub {
            is underscore('SSLError'), 'ssl_error';
        };
    };

    describe camelize => sub {
        it "ActiveModel" => sub {
            is camelize('active_model'), 'ActiveModel';
        };

        it "ActiveModel" => sub {
            is camelize('active_model/errors'), 'ActiveModel::Errors';
        };

        it 'SSLError' => sub {
            is camelize(underscore('SSLError')), 'SslError';
        };
    };

    describe humanize => sub {
        my %cases = (
            "Employee salary" => ['employee_salary'],
            "Author" => ['author_id'],
            "author" => ['author_id', {capitalize => 0}],
            "Id"     => ['_id'],
        );
        for my $case ( keys %cases ) {
            it $case => sub {
                is humanize( @{ $cases{$case} } ), $case;
            };
        }
    };

    describe titleize => sub {
        my %cases = (
            'man from the boondocks'  => "Man From The Boondocks",
            'x-men: the last stand'   => "X Men: The Last Stand",
            'TheManWithoutAPast'      => "The Man Without A Past",
            'raiders_of_the_lost_ark' => "Raiders Of The Lost Ark",
        );
        for my $case ( keys %cases ) {
            it $case => sub {
                is titleize( $case ), $cases{$case};
            };
        }
    };

};

runtests unless caller;
