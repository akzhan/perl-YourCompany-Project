use YourCompany::Test::UTF8;

describe "YourCompany::Util::Redis" => sub {

    it 'should export r_default from default sesction in config' => sub {
        use_ok "YourCompany::Util::Redis", qw(
            r_default
        );
    };

    it 'should set var' => sub {
        lives_ok {
            YourCompany::Util::Redis->default->set('var', 1, EX => 10);
        } '';
    };

    it 'and get var' => sub {
        lives_and {
            is YourCompany::Util::Redis->default->get('var'), 1;
        } '';
    };
};

runtests unless caller;
