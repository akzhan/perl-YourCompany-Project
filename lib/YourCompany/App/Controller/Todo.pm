package YourCompany::App::Controller::Todo;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_CREATED );

use parent 'YourCompany::App::Controller';

sub _row_to_json( $self, $row ) {
    my $json = $row->TO_JSON;

    my $url = $self->url_for( 'todo_url', id => $row->id );

    $json->{url} = $url->to_abs;

    return $json;
}

sub index( $self ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    return $self->render(
        json => [
            map { $self->_row_to_json($_) } @{ $self->model->list() },
        ],
    );
}

sub single( $self ) {
    my $id = ''. $self->param('id');

    return $self->render(
        json => $self->_row_to_json( $self->model->single($id) ),
    );
}

sub create( $self ) {
    my $fields = $self->req->json;

    return $self->render(
        json   => $self->_row_to_json( $self->model->create($fields) ),
        status => HTTP_CREATED,
    );
}

sub update( $self ) {
    my $id     = ''. $self->param('id');
    my $fields = $self->req->json;

    return $self->render(
        json => $self->_row_to_json( $self->model->update( $id, $fields ) ),
    );
}

sub delete( $self ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my $id = ''. $self->param('id');

    $self->model->delete($id);

    return $self->render( text => '' );
}

sub delete_all( $self ) {
    $self->model->delete_all;

    return $self->render( text => '' );
}

1;
