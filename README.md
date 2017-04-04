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
