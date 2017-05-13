package YourCompany::App::Controller::Cors;

use YourCompany::Perl::UTF8;

use parent 'YourCompany::App::Controller';

sub options( $self ) {
    return $self->render( text => '' );
}

1;
