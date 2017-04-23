package YourCompany::Plack::Error;

=encoding utf-8

=head1 NAME

YourCompany::Plack::Error

=head1 DESCRIPTION

L<Plack::Middleware::HTTPExceptions> friendly exception class.

Has code and messages, but returns errors instead of messages in JSON.

Additionaly this class exports all L<HTTP::Status> constants.

=cut

use Mojo::Base -base;
use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_INTERNAL_SERVER_ERROR );
use Scalar::Util qw( blessed );
use Mojo::JSON qw( encode_json false );
use Exporter ();

use overload '""' => 'stringify';
use overload 'ne' => 'not_equal';
use overload 'eq' => 'equal';

has code  => HTTP_INTERNAL_SERVER_ERROR; # name to meet Plack::Middleware::HTTPExceptions

has messages => sub { return []; };

sub message( $self, @values ) {
    if ( scalar @values ) {
        push @{ $self->messages }, @values;
        return $self;
    }
    return $self->stringify();
}

sub stringify {
    my $self = shift;

    return join("\n", @{ $self->messages });
}

sub not_equal {
    my ( $x, $y ) = @_;

    return ref($x) ne ref($y) || "$x" ne "$y";
}

sub equal {
    my ( $x, $y ) = @_;

    return ref($x) eq ref($y) && "$x" eq "$y";
}

sub TO_JSON( $self ) {
    return {
        success => false,
        status  => $self->code,
        errors  => $self->messages,
    };
}

sub to_render( $self ) {
    return (
        json    => $self->TO_JSON,
        status  => $self->code,
    );
}

sub as_string( $self ) { # to meet Plack::Middleware::HTTPExceptions
    return encode_json( $self->TO_JSON() );
}

sub throw( $class, $code, @messages ) {
    if ( blessed($code) && $code->isa(__PACKAGE__) ) {
        # we got Error
        die $code; ## no critic (ErrorHandling::RequireCarping)
    }

    unless ( scalar( @messages ) ) {
        # we got only message
        @messages = ( "$code" );
        $code     = HTTP_INTERNAL_SERVER_ERROR;
    }

    die $class->new( ## no critic (ErrorHandling::RequireCarping)
        code     => $code,
        messages => [ @messages ],
    );
}

=head2 import

Exports L<HTTP::Status> constants in turn.

=cut

sub import {
    my $callpkg = caller;
    Exporter::export_to_level( 'HTTP::Status', 1, $callpkg, ':constants' );
    1;
}

1;

__END__

Moose-based implementation details just for example

use Moose;
use namespace::clean -except => 'meta';

has code => ( # name to meet Plack::Middleware::HTTPExceptions
    is      => 'ro',
    isa     => 'Int',
    default => HTTP_INTERNAL_SERVER_ERROR,
);

has messages => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub {
        return [];
    },
);

__PACKAGE__->meta->make_immutable;
