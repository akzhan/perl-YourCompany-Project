# YourCompany Project in Perl

## Installation

Requirements:

 *  Perl 5.20+
 *  `cpanm`

```bash
cpanm --installdeps .

# for development purposes
cpanm --installdeps --with-develop .
```

## Database

Note that our installation uses Postgres 9.6.

You should create user and database.

```
# take a note that UTF-8 may be known as UTF8
# take a note that ru_RU may be known as ru-RU
psql postgres
postgres => CREATE USER yourself PASSWORD 'protected';
postgres => CREATE DATABASE yourdatabase OWNER=yourself ENCODING=utf8 LC_COLLATE='ru_RU.UTF-8' TEMPLATE=template0;
postgres => \q
```

and as usualy do "[sqitch](http://sqitch.org/) deploy".


## Unit tests

```bash
prove t -r
```

## Critique

```bash
script/plint lib
```

## REPL

```bash
script/re.pl
```

## pgcli

Install [pgcli](http://pgcli.com).

```bash
script/pgcli
```
