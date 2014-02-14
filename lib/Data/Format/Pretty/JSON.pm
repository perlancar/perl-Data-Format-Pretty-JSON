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
    my $interactive = (-t STDOUT);
    my $pretty = $opts->{pretty} // 1;
    my $color  = $opts->{color} // $ENV{COLOR} // $interactive //
        $opts->{pretty};
    my $linum  = $opts->{linum} // $ENV{LINUM} // $interactive //
        $opts->{pretty};
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

By default color is turned on when interactive (unless forced off via color=>0
or environment C<COLOR=0>). By default pretty printing is turned on (unless
turned off via pretty=>0) and line numbers (unless turned off via when
pretty=>0). By default line numbers are printed when interactive (unless turned
off via by linum=>0 or environment C<LINUM=0>).

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

=item * color => BOOL (default: 1 on interactive)

Whether to enable coloring. The default is the enable only when running
interactively.

=item * pretty => BOOL (default: 1)

Whether to pretty-print JSON.

=item * linum => BOOL (default: 1 on interactive)

Whether to add line numbers. The default is the enable only when running
interactively.

=back

=head2 content_type() => STR

Return C<application/json>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).

=head2 LINUM => BOOL

Set C<linum> option (if unset).


=head1 FAQ

=head2 How do I turn off line numbers?

You can use environment L<LINUM=0> or set option C<< linum => 0 >>.


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut
