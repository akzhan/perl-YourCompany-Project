package YourCompany::Util::StringCase;

=head1 NAME

YourCompany::Util::StringCase

=head1 DESCRIPTION

String case convertion utilities.

Inspired by Ruby on Rails.

=cut

use YourCompany::Perl::UTF8;

use Exporter qw( import );

use constant {
    NO_MATCH_RE => qr/(?=a)b/,
};

my %acronyms = ();
my $acronym_regex = NO_MATCH_RE;

=head1 FUNCTIONS

=head2 acronym

    acronym('HTML');
    titleize('html');     # => 'HTML'
    camelize('html');     # => 'HTML'
    underscore('MyHTML'); # => 'my_html'

Specifies a new acronym. An acronym must be specified as it will appear in a camelized string.
An underscore string that contains the acronym will retain the acronym when passed to L</camelize>, L</humanize>, or L</titleize>.
A camelized string that contains the acronym will maintain the acronym when titleized or humanized,
and will convert the acronym into a non-delimited single lowercase word when passed to L</underscore>.

=cut

sub acronym {
    my $word = $_[0];
    $acronyms{lc $word} = $word;
    _setup_acronym_regex();
}

sub _setup_acronym_regex {
    if ( scalar %acronyms ) {
        my $patt = join('|', map { quotemeta } values %acronyms);
        $acronym_regex = qr/$patt/;
    }
    else {
        $acronym_regex = NO_MATCH_RE;
    }
    1;
}

=head2 capitalize

    $str = capitalize($str);

Returns a copy of str with the first character converted to uppercase and the remainder to lowercase.

Note: case conversion is effective only in ASCII region.

This function is L</ucfirst> internally, but exists to made easy convertion from Ruby sources.

=cut

*{capitalize} = \&CORE::ucfirst;

=head2 camelize

    camelize('active_model')            # => "ActiveModel"
    camelize('active_model', 0)         # => "activeModel"
    camelize('active_model/errors')     # => "ActiveModel::Errors"
    camelize('active_model/errors', 0)  # => "activeModel::Errors"

By default, L</camelize> converts strings to UpperCamelCase.
If the argument to L</camelize> is true then L</camelize> produces lowerCamelCase.

L</camelize> will also convert '/' to '::'' which is useful for converting paths to namespaces.

As a rule of thumb you can think of L</camelize> as the inverse of L</underscore>,
though there are cases where that does not hold:

    camelize(underscore('SSLError')) # => "SslError"

=cut

sub camelize {
    my ( $term, $uppercase_first_letter ) = @_;
    $uppercase_first_letter //= 1;
    if ( $uppercase_first_letter ) {
        $term =~ s%^([a-z\d]*)%( $acronyms{$1 // ''} ) // capitalize($1)%e;
    }
    else {
        $term =~ s/^((?:$acronym_regex(?=\b|[A-Z_])|\w))/\L$1\E/;
    }
    $term =~ s^(?:_|(\/))([a-z\d]*)^($1 // ''). ( $acronyms{$1 // ''} // capitalize($2) )^ge;
    $term =~ s|/|::|g;
    $term;
}

=head2 underscore

    underscore('ActiveModel')         # => "active_model"
    underscore('ActiveModel::Errors') # => "active_model/errors"

Makes an underscored, lowercase form from the expression in the string.

Changes '::' to '/' to convert namespaces to paths.

=cut

sub underscore {
    my $word = $_[0];
    return $word if $word !~ m/[A-Z-]|::/;
    $word =~ s|::|/|g;
    $word =~ s/(?:(?<=([A-Za-z\d]))|\b)($acronym_regex)(?=\b|[^a-z])/ ( ( $1 && '_' ) || '' ). lc($2) /ge;
    $word =~ s/([A-Z\d]+)([A-Z][a-z])/$1_$2/g;
    $word =~ s/([a-z\d])([A-Z])/$1_$2/g;
    $word =~ tr/-/_/;
    lc $word;
}

=head2 dasherize

    $dasherized_word = dasherize($underscored_word);

Replaces underscores with dashes in the string.

=cut

sub dasherize {
    my $word = $_[0];
    $word =~ tr/_/-/;
    $word;
}

=head2 humanize

    humanize('employee_salary')              # => "Employee salary"
    humanize('author_id')                    # => "Author"
    humanize('author_id', capitalize: false) # => "author"
    humanize('_id')                          # => "Id"

Tweaks an attribute name for display to end users.

Specifically, humanize performs these transformations:

* Applies human inflection rules to the argument.
* Deletes leading underscores, if any.
* Removes a "_id" suffix if present.
* Replaces underscores with spaces, if any.
* Downcases all words except acronyms.
* Capitalizes the first word.

The capitalization of the first word can be turned off by setting the capitalize option to false (default is true).

=cut

sub humanize {
    my ( $word, $options ) = @_;

    $options //= { capitalize => 1 };
    $options->{capitalize} //= 1;

    # inflections.humans.each { |(rule, replacement)| break if result.sub!(rule, replacement) }

    $word =~ s/\A_+//;
    $word =~ s/_id\z//;
    $word =~ tr/_/ /;

    $word =~ s|([a-z\d]*)|
         $acronyms{$1} // lc($1)
    |ge;

    if ( $options->{capitalize} ) {
        $word =~ s/\A(\w)/\U$1\E/;
    }

    $word;
}

=head2 titleize

    titleize('man from the boondocks')   # => "Man From The Boondocks"
    titleize('x-men: the last stand')    # => "X Men: The Last Stand"
    titleize('TheManWithoutAPast')       # => "The Man Without A Past"
    titleize('raiders_of_the_lost_ark')  # => "Raiders Of The Lost Ark"

Capitalizes all the words and replaces some characters in the string to create a nicer looking title.
L</titleize> is meant for creating pretty output.

=cut

sub titleize {
    my $word = $_[0];
    $word = humanize(underscore($word));
    $word =~ s/\b((?<!['â`])[a-z])/capitalize($1)/ge;
    $word;
}

=head2 get_acronyms

    my $acromyms_to_save = get_acronyms;

Gets copy of acronyms to be set later through L</set_acronyms>.

=cut

sub get_acronyms {
    return { %acronyms };
}

=head2 set_acronyms

    set_acronyms( $acromyms_to_set )

Sets acronyms got earlier by L</get_acronyms>.

=cut

sub set_acronyms {
    my $acronyms_to_set = $_[0];
    %acronyms = %{ $acronyms_to_set };
    _setup_acronym_regex();
}

=head2 reset_acronyms

    reset_acronyms

Resets acronyms to empty set.

=cut

sub reset_acronyms {
    set_acronyms({});
}

our @EXPORT_OK = qw(
    &acronym
    &camelize
    &capitalize
    &dasherize
    &underscore
    &humanize
    &titleize
    &get_acronyms
    &set_acronyms
    &reset_acronyms
);

1;
