package YourCompany::Util::JSONColumn;

use YourCompany::Perl::UTF8;

use JSON::XS ();
use Encode qw( encode_utf8 decode_utf8 );

sub register_column {
    my $self = shift;
    my ( $column, $info, $args ) = @_;
    $self->next::method(@_);

    return unless defined $info->{json};

    my %modifiers = (
        utf8 => 1,
    );

    %modifiers = ( %modifiers, %{$info->{json}} ) if ref $info->{json};

    my $jsoner = JSON::XS->new;
    for my $mod ( keys %modifiers ) {
        my $mod_args = $modifiers{$mod};
        if ( ref($mod_args) ne 'ARRAY' ) {
            $mod_args = [ $mod_args ];
        }
        $jsoner = $jsoner->$mod( @{ $mod_args } );
    }

    my $unfreezer = sub {
        my $value = shift;
        return undef  unless defined $value;
        $value = encode_utf8( $value );
        return $jsoner->decode( $value );
    };

    my $freezer = sub {
        my $value = shift;
        return undef  unless defined $value;
        $value = $jsoner->encode( $value );
        $value = decode_utf8( $value );
        return $value;
    };

    $self->inflate_column(
        $column => {
            inflate => $unfreezer,
            deflate => $freezer,
        },
    );
}

1;
