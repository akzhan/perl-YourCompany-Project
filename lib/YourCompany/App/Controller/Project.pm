package YourCompany::App::Controller::Project;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_OK HTTP_CREATED );

use parent 'YourCompany::App::Controller';

sub index { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ( $self ) = @_;

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

sub create {
    my ( $self ) = @_;

    my $fields = $self->req->json;

    return $self->render( json => {
        success => \1,
        status  => HTTP_CREATED,
        model   => $self->model('Project')->create($fields),
    } );
}

sub update {
    my ( $self ) = @_;

    my $id     = ''. $self->param('id');
    my $fields = $self->req->json;

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model('Project')->update( $id, $fields ),
    } );
}

sub delete { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ( $self ) = @_;

    my $id = ''. $self->param('id');

    $self->model('Project')->delete($id);

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
    } );
}

1;
