# Postgres Describe

This library provides a `Mix` task that documents PostgreSQL database tables
in files within the directory tree.

## Installation

Add `postgres_describe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:postgres_describe, "~> 0.1.0"}
  ]
end
```

And `mix deps.get`.

## Basic Usage

The following configuration keys are the minimum required, and an example
follows:

- `host` # Your PG host
- `port` # PG port
- `user` # Your PG user
- `password` # Your PG password
- `database` # Your PG database name
- `write_dir` # Where we should write your description files
- `tables` # A map: keys are schemas in your database (at a minimum you probably want `public`), and values are lists of table names within that schema

```elixir
config :postgres_describe,
  host: "localhost",
  port: 5432,
  user: "myuser",
  password: "mypassword",
  database: "mydatabase",
  write_dir: "/tmp",
  tables: %{
    public: [
      "table_1",
      "table_2"
    ],
    another_schema: [
      "table_3",
      "table_4"
    ]
  }
```

Then run the generator from the root of your application:

```bash
$ mix PostgresDescribe
```

Full docs can be found [online](https://hexdocs.pm/postgres_describe).
