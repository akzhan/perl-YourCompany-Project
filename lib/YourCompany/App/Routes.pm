package YourCompany::App::Routes;

use YourCompany::Perl::UTF8;

sub collect {
    my ( $class, $routes ) = @_;

    my $projects = $routes->any('/projects')->to( controller => 'project' );

    $projects->get('/')->to('#index');
    $projects->get('/:id' => [ id => qr/\d+/ ])->to('#single');
}

1;

