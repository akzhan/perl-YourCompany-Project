package YourCompany::App::Api::Project;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_OK HTTP_CREATED );
use Mojo::JSON qw( true );

use parent 'YourCompany::App::Controller';

sub index { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my $self = shift->openapi->valid_input or return;

    return $self->render( openapi => {
        success => true,
        status  => HTTP_OK,
        model   => $self->model('Project')->list(),
    } );
}

sub single { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my $self = shift->openapi->valid_input or return;

    my $id = $self->validation->param("id");

    return $self->render( openapi => {
        success => true,
        status  => HTTP_OK,
        model   => $self->model('Project')->single($id),
    } );
}

sub create {
    my $self = shift->openapi->valid_input or return;

    my $fields = $self->validation->param("body");

    return $self->render( openapi => {
        success => true,
        status  => HTTP_CREATED,
        model   => $self->model('Project')->create($fields),
    }, status => HTTP_CREATED );
}

sub update {
    my $self = shift->openapi->valid_input or return;

    my $id     = $self->validation->param("id");
    my $fields = $self->validation->param("body");

    return $self->render( openapi => {
        success => true,
        status  => HTTP_OK,
        model   => $self->model('Project')->update( $id, $fields ),
    } );
}

sub delete { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my $self = shift->openapi->valid_input or return;

    my $id     = $self->validation->param("id");

    $self->model('Project')->delete($id);

    return $self->render( openapi => {
        success => true,
        status  => HTTP_OK,
    } );
}

1;
