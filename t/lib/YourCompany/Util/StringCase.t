use YourCompany::Test::UTF8;

describe "YourCompany::Util::StringCase" => sub {

    it 'should be used' => sub {
        use_ok "YourCompany::Util::StringCase", qw(
            camelize
            underscore
            dasherize
            humanize
            titleize
            acronym
            get_acronyms
            set_acronyms
            reset_acronyms
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

    describe dasherize => sub {
        it "shoult replace '_' with '-'" => sub {
            is dasherize("that_do__you_think___"), "that-do--you-think---";
        };
    };

    describe acronym => sub {
        describe html_string => sub {
            my $acronyms;

            before all => sub {
                reset_acronyms();
            };

            after all => sub {
                reset_acronyms();
            };

            it "should camelize to HtmlString before acronym" => sub {
                is camelize("html_string"), "HtmlString";
            };

            it "should get_acronyms" => sub {
                lives_ok { $acronyms = get_acronyms(); } '';
            };

            it "should do acronym" => sub {
                lives_ok { acronym("HTML") } '';
            };

            it "should camelize to HTMLString after acronym" => sub {
                is camelize("html_string"), "HTMLString";
            };

            it "should set_acronyms" => sub {
                lives_ok { set_acronyms($acronyms); } '';
            };

            it "should camelize to HtmlString after set_acronyms to initial state" => sub {
                is camelize("html_string"), "HtmlString";
            };
        };
    };
};

runtests unless caller;
