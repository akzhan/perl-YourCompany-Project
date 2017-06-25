use YourCompany::Perl::UTF8;

use Plack::Handler::Starman;
use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::RedisFast;

use YourCompany::Util::Redis ();

my $app = Plack::Util::load_psgi "./script/cli";

builder {
    enable 'Session',
      state => Plack::Session::State::Cookie->new(
        expires => YourCompany::Config->app->{session}{expires} ),
      store => Plack::Session::Store::RedisFast->new(
        redis   => YourCompany::Util::Redis->session,
        expires => YourCompany::Config->app->{session}{expires},
      );

    $app;
};
