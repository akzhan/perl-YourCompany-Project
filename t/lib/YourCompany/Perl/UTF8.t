package YourCompany::Test::Perl;

use mro ();
use YourCompany::Test::UTF8;

use_ok "YourCompany::Perl::UTF8";

is mro::get_mro(__PACKAGE__), 'c3', "Current package set to use c3";

done_testing;
