package YourCompany::App::Controller;

use YourCompany::Perl::UTF8;

use parent 'Mojolicious::Controller';

=head2 model_name

    $c->model_name

Returns associated model name.

Its last part of controller class name by default.

=cut

sub model_name( $self ) {
    return ( ref($self) =~ s/^.+:://r );
}

=head2 model

    $c->model

    $c->model('ModelClass')

    $c->model('ModelClass', @args)

Returns associated model or specified one.

See also L</model_name>.

=cut

sub model( $self, @args ) {
    @args = ( $self->model_name )  unless scalar @args;
    return $self->SUPER::model( @args );
}

1;
