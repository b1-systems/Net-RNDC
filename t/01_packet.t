#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use Net::RNDC::Packet;

## new / bad
throws_ok { Net::RNDC::Packet->new(); }
	qr/Missing required argument 'key'/,
	"new() without 'key' fails";

throws_ok { Net::RNDC::Packet->new(key => 'aabc', data => 'bad'); }
	qr/Argument 'data' must be a HASH/,
	"new() with non-HASH 'data' fails";

throws_ok { Net::RNDC::Packet->new(key => 'aabc', version => 'cat'); }
	qr/Argument 'version' must be a number/,
	"new() with non-numeric 'version' fails";

throws_ok { Net::RNDC::Packet->new(key => 'aabc', nonce => 'dog'); }
	qr/Argument 'nonce' must be a number/,
	"new() with non-numeric 'nonce' fails";

## new / good
my $p;

ok($p = Net::RNDC::Packet->new(key => 'aabc'), "new(key => '..')");
isa_ok($p, 'Net::RNDC::Packet', "Got a packet");
is($p->{key}, 'aabc', "key is correct");

ok($p = Net::RNDC::Packet->new(key => 'aabc', nonce => 121),
	"new(key => '..', nonce => '..'");
isa_ok($p, 'Net::RNDC::Packet', "Got a packet");
is($p->{data}{_ctrl}{_nonce}, 121, "nonce is correct");

## data
$p = Net::RNDC::Packet->new(key => 'aabc', data => { cat => \"bird" });
ok($p, "Got a packet");

ok(!$p->data, "->data() failed with scalarref in data section");
like($p->error,
	qr/'Unknown data type 'SCALAR' in _value_towire'/,
	"Unknown data type 'SCALAR' error");

done_testing;
