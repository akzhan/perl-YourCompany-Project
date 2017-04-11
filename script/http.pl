use YourCompany::Perl::UTF8;

use Plack::Handler::Starman;
use Plack::Builder;

my $app = Plack::Util::load_psgi "./script/cli";

builder {
    $app;
};
