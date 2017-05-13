package YourCompany::App::Routes;

use YourCompany::Perl::UTF8;

sub collect( $class, $routes ) {
    $routes->options('*')->to( 'cors#options' );

    my $projects = $routes->any('/projects')->to( controller => 'project' );

    $projects->get('/')->to('#index');
    $projects->get( '/:id' => [ id => qr/\d+/ ] )->to('#single');
    $projects->post('/')->to('#create');
    $projects->put( '/:id' => [ id => qr/\d+/ ] )->to('#update');
    $projects->delete( '/:id' => [ id => qr/\d+/ ] )->to('#delete');
}

1;

