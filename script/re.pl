#!/usr/bin/env perl

use strict;
use warnings;

use lib::abs qw( ../lib );

use YourCompany::Perl::UTF8;

use Devel::REPL;

use SendMessage::DB;
use SendMessage::Util::Redis;

my $repl = Devel::REPL->new;
$repl->load_plugin($_) for qw(
	History LexEnv Completion
	CompletionDriver::INC CompletionDriver::Methods CompletionDriver::LexEnv
);

$repl->run;
