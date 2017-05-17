use YourCompany::Test::UTF8;

use YourCompany::DB;

describe "YourCompany::DB::Project" => sub {
    it 'should search all' => sub {
        lives_ok {
            YourCompany::DB->rs('Project')->search(undef, {
                offset => 0,
                rows   => 1,
            })->all;
        } '';
    };
};

runtests unless caller;
