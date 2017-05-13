package YourCompany::App;

=encoding utf-8

=head1 NAME

YourCompany::App

=head1 DESCRIPTION

YourCompany Web Application.

=cut

use Mojo::Base qw( Mojolicious );
use YourCompany::Perl::UTF8;

use YourCompany::Config;
use YourCompany::App::Routes;

=head1 METHODS

=head2 startup

    $app->startup;

This method will run once at server start

=cut

sub startup( $self ) {
    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    $self->plugin('CORS');

    $self->plugin('Model' => {
        namespaces => [
            'YourCompany::App::Model',
        ],
    });

    $self->plugin('OpenAPI' => {
        url => $self->home->rel_file("config/api.json"),
    });

    $self->plugin('YourCompany::App::Plugin::Common');

    $self->secrets(['yourcompany']);

    # Router
    YourCompany::App::Routes->collect( $self->routes );
}

1;
