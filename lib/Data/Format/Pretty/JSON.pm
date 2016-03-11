package Data::Format::Pretty::JSON;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

sub content_type { "application/json" }

sub format_pretty {
    my ($data, $opts) = @_;
    $opts //= {};

    state $json;
    my $interactive = (-t STDOUT);
    my $pretty = $opts->{pretty} // 1;
    my $color  = $opts->{color} // $ENV{COLOR} // $interactive //
        $opts->{pretty};
    my $linum  = $opts->{linum} // $ENV{LINUM} // 0;
    if ($color) {
        require JSON::Color;
        JSON::Color::encode_json($data, {pretty=>$pretty, linum=>$linum})."\n";
    } else {
        if (!$json) {
            require JSON::MaybeXS;
            $json = JSON::MaybeXS->new->utf8->allow_nonref;
        }
        $json->pretty($pretty);
        if ($linum) {
            require String::LineNumber;
            String::LineNumber::linenum($json->encode($data));
        } else {
            $json->encode($data);
        }
    }
}

1;
# ABSTRACT: Pretty-print data structure as JSON

=for Pod::Coverage ^(new)$

=head1 SYNOPSIS

 use Data::Format::Pretty::JSON qw(format_pretty);
 print format_pretty($data);


=head1 DESCRIPTION

This module uses L<JSON::MaybeXS> or L<JSON::Color> to encode data as JSON.


=head1 FUNCTIONS

=head2 format_pretty($data, \%opts)

Return formatted data structure as JSON. Options:

=over 4

=item * color => BOOL (default: from env or 1 on interactive)

Whether to enable coloring. The default is the enable only when running
interactively.

=item * pretty => BOOL (default: 1)

Whether to pretty-print JSON.

=item * linum => BOOL (default: from env or 0)

Whether to add line numbers.

=back

=head2 content_type() => STR

Return C<application/json>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).

=head2 LINUM => BOOL

Set C<linum> option (if unset).


=head1 FAQ


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut
