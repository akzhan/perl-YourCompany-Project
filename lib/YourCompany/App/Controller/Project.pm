package YourCompany::App::Controller::Project;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_OK HTTP_CREATED );

use parent 'YourCompany::App::Controller';

sub index { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ( $self ) = @_;

warn 'fuck';

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model('Project')->list(),
    } );
}

sub single { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ( $self ) = @_;

    my $id = ''. $self->param('id');

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model('Project')->single($id),
    } );
}

1;
