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

By default, Sqitch will read sqitch.conf in the current directory for settings. But it will also read ~/.sqitch/sqitch.conf for user-specific settings. Get it from git and setup.

```bash
sqitch config --user user.name 'user_login'
sqitch config --user user.email 'email@example.com'
```

You should correctly set Git line endings - we use Unix ones.

```
git config --global core.autocrlf input
```

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

and open [swagger page](http://localhost:7777/swagger-ui/dist/index.html).

## CREDITS

 * Database plan to [Max Travinichev](mailto:uatrigger@gmail.com) [@travinichev](https://github.com/travinichev).
 * Mojolicious application to [Vladimir Melnichenko](mailto:melnichenkovv@gmail.com).
