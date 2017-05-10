package YourCompany::Util::BooleanColumn;

use YourCompany::Perl::UTF8;

use Mojo::JSON qw( true false );

sub register_column {
    my $self = shift;
    my ( $column, $info, $args ) = @_;
    $self->next::method(@_);

    return unless $info->{bool} || $info->{boolean};

    $self->inflate_column(
        $column => {
            inflate => sub {
                my $value = shift;
                return undef  unless defined $value;
                return $value ? true : false;
            },
            deflate => sub {
                my $value = shift;
                return undef  unless defined $value;
                return $value ? 1 : 0;
            },
        },
    );
}

1;
