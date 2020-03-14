package Net::OpenVAS::OMP::Response;

use strict;
use warnings;
use utf8;
use feature ':5.10';

use Net::OpenVAS::Error;

use XML::Simple qw( :strict );
use Carp;

use overload q|""| => 'raw', fallback => 1;

sub new {

    my ( $class, %args ) = @_;

    my $request  = $args{'request'};
    my $response = $args{'response'};
    my $command  = $request->command;

    croak q/Net::OpenVAS::OMP::Response ( 'request' => ... ) must be "Net::OpenVAS::OMP::Request" instance/
        if ( !ref $request eq 'Net::OpenVAS::OMP::Request' );

    my $result      = XMLin( $response, ForceArray => 1, KeyAttr => "${command}_response" );
    my $status      = delete( $result->{status} );
    my $status_text = delete( $result->{status_text} );
    my $error       = undef;

    if ( $status >= 400 ) {
        $error = Net::OpenVAS::Error->new( $status_text, $status );
    }

    my $self = {
        result      => $result,
        status      => $status + 0,
        raw         => $response,
        request     => $request,
        status_text => $status_text,
        error       => $error,
    };

    return bless $self, $class;

}

sub result {
    my ($self) = @_;
    return $self->{result};
}

sub error {
    my ($self) = @_;
    return $self->{error};
}

sub status {
    my ($self) = @_;
    return $self->{status};
}

sub is_ok {
    my ($self) = @_;
    return ( $self->status == 200 ) ? 1 : 0;
}

sub is_created {
    my ($self) = @_;
    return ( $self->status == 201 ) ? 1 : 0;
}

sub is_accepted {
    my ($self) = @_;
    return ( $self->status == 202 ) ? 1 : 0;
}

sub is_forbidden {
    my ($self) = @_;
    return ( $self->status == 403 ) ? 1 : 0;
}

sub is_not_found {
    my ($self) = @_;
    return ( $self->status == 404 ) ? 1 : 0;
}

sub is_busy {
    my ($self) = @_;
    return ( $self->status == 409 ) ? 1 : 0;
}

sub is_server_error {
    my ($self) = @_;
    return ( $self->status >= 500 ) ? 1 : 0;
}

sub status_text {
    my ($self) = @_;
    return $self->{status_text};
}

sub raw {
    my ($self) = @_;
    return $self->{raw};
}

sub command {
    my ($self) = @_;
    return $self->{request}->command;
}

sub request {
    my ($self) = @_;
    return $self->{request};
}

1;
