package YourCompany::App::Controller::Project;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_OK HTTP_CREATED );

use parent 'YourCompany::App::Controller';

sub index( $self ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model->list(),
    } );
}

sub single( $self ) {
    my $id = ''. $self->param('id');

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model->single($id),
    } );
}

sub create( $self ) {
    my $fields = $self->req->json;

    return $self->render( json => {
        success => \1,
        status  => HTTP_CREATED,
        model   => $self->model->create($fields),
    }, status => HTTP_CREATED );
}

sub update( $self ) {
    my $id     = ''. $self->param('id');
    my $fields = $self->req->json;

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
        model   => $self->model->update( $id, $fields ),
    } );
}

sub delete( $self ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my $id = ''. $self->param('id');

    $self->model->delete($id);

    return $self->render( json => {
        success => \1,
        status  => HTTP_OK,
    } );
}

1;
