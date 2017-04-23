package YourCompany::App;

use YourCompany::Perl::UTF8;

use Mojo::Base qw( Mojolicious );

use YourCompany::App::Routes;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    $self->plugin('Model' => {
        namespaces => [
            'YourCompany::Model',
        ],
    });

    $self->plugin('OpenAPI' => {
        url => $self->home->rel_file("config/api.json"),
    });

    $self->plugin('YourCompany::Plugin::Common');

    $self->secrets(['yourcompany']);

    # Router
    YourCompany::App::Routes->collect( $self->routes );
}

1;
