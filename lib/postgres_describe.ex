defmodule PostgresDescribe do
  @moduledoc """
  This library provides a `Mix` task that documents PostgreSQL database tables
  in files within the directory tree.
  """

  use Private

  # ------------------------------------------ #

  @doc """
  Main entry point into `PostgresDescribe`'s library code.

  Pulls configuration from the environment. The following configuration keys are
  the minimum required. An example can be found in the README.

  - `host` # Your PG host
  - `port` # PG port
  - `user` # Your PG user
  - `password` # Your PG password
  - `database` # Your PG database name
  - `write_dir` # Where we should write your description files
  - `tables` # A map: keys are schemas in your database (at a minimum you probably want `public`), and values are lists of table names within that schema
  """
  def go! do
    config = %{
      host: Application.fetch_env!(:postgres_describe, :host),
      port: Application.fetch_env!(:postgres_describe, :port),
      user: Application.fetch_env!(:postgres_describe, :user),
      password: Application.fetch_env!(:postgres_describe, :password),
      database: Application.fetch_env!(:postgres_describe, :database),
      write_dir: Application.fetch_env!(:postgres_describe, :write_dir),
      tables: Application.fetch_env!(:postgres_describe, :tables)
    }
    write_files(config)
  end

  # ------------------------------------------ #

  private do

    defp write_files(%{host: host, port: port, user: user, password: password,
                       database: database, write_dir: write_dir,
                       tables: tables}) do
      File.mkdir_p!(write_dir)
      Enum.each tables, fn({schema, table_list}) ->
        Enum.each table_list, fn(table) ->
          command = build_command(host, port, user, password, database, schema, table)
          run_shell_command(command, &write_output(write_dir, schema, table, &1))
          :ok
        end
      end
    end

  end

  # ------------------------------------------ #

  defp build_command(host, port, user, password, database, schema, table) do
    pg_command = ~s|\\d "#{schema}"."#{table}";|
    ~s|PGPASSWORD="#{password}" psql -h "#{host}" -p #{port} -U "#{user}"  -d "#{database}" -c "#{pg_command}"|
  end

  defp run_shell_command(command, fun) do
    0 = Mix.Shell.cmd(command, fun)
  end

  defp write_output(write_dir, schema, table, output) do
    sch = Atom.to_string(schema)
    dir = Path.join([write_dir, sch])
    path = Path.join([dir, table <> ".txt"])
    File.mkdir_p!(dir)
    File.write!(path, output)
  end
end
