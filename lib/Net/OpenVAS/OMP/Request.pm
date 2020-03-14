package Net::OpenVAS::OMP::Request;

use strict;
use warnings;
use utf8;
use feature ':5.10';

use XML::Simple qw( :strict );

use overload q|""| => 'raw', fallback => 1;

sub new {

    my ( $class, %args ) = @_;

    my $command   = $args{'command'};
    my $arguments = $args{'arguments'};

    my $request = { $command => $arguments };
    my $raw     = XMLout(
        $request,
        NoEscape      => 0,
        SuppressEmpty => 1,
        KeepRoot      => 1,
        KeyAttr       => $command
    );

    chomp($raw);

    my $self = {
        command   => $command,
        arguments => $arguments,
        raw       => $raw,
    };

    return bless $self, $class;

}

sub raw {
    my ($self) = @_;
    return $self->{raw};
}

sub command {
    my ($self) = @_;
    return $self->{command};
}

sub arguments {
    my ($self) = @_;
    return $self->{arguments};
}

1;
