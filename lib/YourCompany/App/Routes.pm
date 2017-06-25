package YourCompany::App::Routes;

use YourCompany::Perl::UTF8;

sub collect ( $class, $routes ) {
    $routes->options('*')->to('cors#options');

    my $projects = $routes->any('/projects')->to( controller => 'project' );

    $projects->get('/')->to('#index');
    $projects->get( '/:id' => [ id => qr/\d+/ ] )->to('#single');
    $projects->post('/')->to('#create');
    $projects->put( '/:id' => [ id => qr/\d+/ ] )->to('#update');
    $projects->delete( '/:id' => [ id => qr/\d+/ ] )->to('#delete');

    # Todo-Backend API (http://www.todobackend.com/)
    my $todos = $routes->any('/todos')->to( controller => 'todo' );

    $todos->get('/')->to('#index');
    $todos->get( '/:id' => [ id => qr/\d+/ ] )->to('#single')->name('todo_url');
    $todos->post('/')->to('#create');
    $todos->patch( '/:id' => [ id => qr/\d+/ ] )->to('#update');
    $todos->delete( '/:id' => [ id => qr/\d+/ ] )->to('#delete');
    $todos->delete('/')->to('#delete_all');
}

1;

