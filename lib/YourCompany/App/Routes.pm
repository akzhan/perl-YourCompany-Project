package YourCompany::App::Routes;

use YourCompany::Perl::UTF8;
use YourCompany::Plack::Error;

sub setup_finder( $class, $routes ) {
    $routes->add_shortcut( finder => sub($r, $ename, $prop_name = 'id') {
        return $r->under( "/:$prop_name" => [ $prop_name => qr/\d+/ ] => sub($c) {
            my $model = $c->model($ename)
                or YourCompany::Plack::Error->throw("Model '$ename' not found");

            $c->stash( model => $model->finder( $c->param($prop_name) ) );

            return 1;
        } );
    } );
}

sub collect( $class, $routes ) {
    $class->setup_finder($routes);

    my $projects = $routes->any('/projects')->to( controller => 'project' );

    $projects->get('/')->to('#index');
    $projects->finder('Project')->get('/')->to('#single');
    $projects->post('/')->to('#create');
    $projects->finder('Project')->put('/')->to('#update');
    $projects->finder('Project')->delete('/')->to('#delete');
}

1;

