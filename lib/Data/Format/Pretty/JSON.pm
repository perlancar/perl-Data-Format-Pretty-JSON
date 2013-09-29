package Data::Format::Pretty::JSON;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

# VERSION

sub content_type { "application/json" }

sub format_pretty {
    my ($data, $opts) = @_;
    $opts //= {};

    state $json;
    my $pretty = $opts->{pretty} // 1;
    my $linum  = $opts->{linum} // $ENV{LINUM} // $opts->{pretty};
    my $color  = $opts->{color} // $ENV{COLOR} // (-t STDOUT);
    if ($color) {
        require JSON::Color;
        JSON::Color::encode_json($data, {pretty=>$pretty, linum=>$linum})."\n";
    } else {
        if (!$json) {
            require JSON;
            $json = JSON->new->utf8->allow_nonref;
        }
        $json->pretty($pretty);
        if ($linum) {
            require SHARYANTO::String::Util;
            SHARYANTO::String::Util::linenum($json->encode($data));
        } else {
            $json->encode($data);
        }
    }
}

1;
# ABSTRACT: Pretty-print data structure as JSON

=head1 SYNOPSIS

 use Data::Format::Pretty::JSON qw(format_pretty);
 print format_pretty($data);

Some example output:

=over 4

=item * format_pretty({a=>1, b=>2})

  1:{
  2:    "a" : 1,
  3:    "b" : 2,
  4:}

By default color is turned on (unless forced off via C<COLOR> environment) as
well as pretty printing (unless turned off via pretty=>1) and line numbers
(unless when pretty=>0 or turned off by linum=>0).

=item * format_pretty({a=>1, b=>2}, {pretty=>0});

 {"a":1,"b":2}

=back


=head1 DESCRIPTION

This module uses L<JSON> to encode data as JSON.


=for Pod::Coverage new

=head1 FUNCTIONS

=head2 format_pretty($data, \%opts)

Return formatted data structure as JSON. Options:

=over 4

=item * color => BOOL

Whether to enable coloring. The default is the enable only when running
interactively. Currently also enable line numbering.

=item * pretty => BOOL (default: 1)

Whether to pretty-print JSON.

=item * linum => BOOL (default: 1 or 0 if pretty=0)

Whether to add line numbers.

=back

=head2 content_type() => STR

Return C<application/json>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).

=head2 LINUM => BOOL

Set C<linum> option (if unset).


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut
