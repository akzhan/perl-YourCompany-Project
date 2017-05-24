use YourCompany::Test::UTF8;

use YourCompany::Util::Redis 'r_default';

describe "YourCompany::Util::Redis" => sub {
    it 'should set var' => sub {
        lives_ok {
            YourCompany::Util::Redis->default->set('var', 1, EX => 10);
        } '';
    };

    it 'and get var' => sub {
        lives_and {
            is r_default->get('var'), 1;
        } '';
    };
};

runtests unless caller;
