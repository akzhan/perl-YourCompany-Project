package YourCompany::Model;

=encoding utf-8

=head1 NAME

YourCompany::Model

=head1 DESCRIPTION

Base L<MojoX::Model> class.

=cut

use YourCompany::Perl::UTF8;

use parent 'MojoX::Model';

use YourCompany::Plack::Error;

=head1 METHODS

=head2 log

    $model->log->debug('Not sure what is happening here');

The logging layer of your model, defaults to a L<Mojo/log> object.

=cut

sub log( $self ) {
    return $self->app->log;
}

1;
