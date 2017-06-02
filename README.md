# YourCompany Project in Perl [![Build Status](https://travis-ci.org/akzhan/perl-YourCompany-Project.svg?branch=master)](https://travis-ci.org/akzhan/perl-YourCompany-Project) [![codecov](https://codecov.io/gh/akzhan/perl-YourCompany-Project/branch/master/graph/badge.svg)](https://codecov.io/gh/akzhan/perl-YourCompany-Project) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![WHISKEY-WARE LICENSE]https://img.shields.io/badge/license-WHISKEY--WARE🥃-452f20.svg)](https://github.com/akzhan/whiskey-ware)

Modern Web project in Perl using [Mojolicious](http://mojolicious.org/) and [DBIx::Class](http://search.cpan.org/~ribasushi/DBIx-Class).

Local configuration settings were embedded into the repository to reduce the learning curve.

This application respond to `/projects` and `/api/projects` routes (see `bin/cli routes` for details).
Also application respond to `/todos` routes of [Todo Backend example](http://todobackend.com/).

`/api/projects` route also provides implementation of [OpenAPI](https://www.openapis.org/) protocol.

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

Note that our boilerplate depends on Postgres 9.5+.

You should create user and database.

```
psql postgres
postgres => CREATE USER yourself PASSWORD 'protected';
postgres => CREATE DATABASE yourdatabase OWNER=yourself ENCODING=utf8;
postgres => \q
```

and, as usually, do "[sqitch](http://sqitch.org/) deploy".

By default, Sqitch will read sqitch.conf in the current directory for settings. But it will also read ~/.sqitch/sqitch.conf for user-specific settings. Get it from git and setup.

```bash
sqitch config --user user.name 'user_login'
sqitch config --user user.email 'email@example.com'
```

## Configuration

Usually You need to override *config/defaults.yml*, *config/development.yml*, *config/test.yml*, *config/production.yml* with *config/local.yml* and exclude local settings from VCS tracking.

## Usage

### Run

```bash
bin/http # to run HTTP server
bin/cli routes # mojo cli
```

### Unit tests

```bash
prove t -r
```

### Critique

```bash
bin/plint lib
```

### REPL

```bash
bin/re.pl
```

### psql

```bash
bin/psql
```

### pgcli

Install [pgcli](http://pgcli.com).

```bash
bin/pgcli
```

## Swagger UI

YourCompany Project supports [OpenAPI](https://www.openapis.org/) and allows to visualize and interact with the API’s resources
through [Swagger UI](http://swagger.io/swagger-ui/).

Simply do

```bash
git submodule update --init
bin/http
```

and open [its swagger page](http://localhost:7777/swagger-ui/dist/index.html).

## CREDITS

 * All together to [@akzhan](https://akzhan.github.io/).
 * Database plan to [Max Travinichev](mailto:uatrigger@gmail.com) [@travinichev](https://github.com/travinichev).
 * Mojolicious application to [Vladimir Melnichenko](mailto:melnichenkovv@gmail.com).
 * find or throw pattern to Eugen Konkov [@KES777](https://github.com/KES777).
 * Hint to aliasing of core functions to [Anton Petrusevich](http://search.cpan.org/~antonpetr/) [@jef-sure](https://github.com/jef-sure).
