package YourCompany::App::Controller::Cors;

use YourCompany::Perl::UTF8;

use parent 'YourCompany::App::Controller';

# Every OPTIONS request will be OK.
# CORS headers set by `after_render`.
sub options( $self ) {
    return $self->render( text => '' );
}

1;
