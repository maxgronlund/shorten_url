defmodule ShortenUrlWeb.UrlHelper do
  @spec host_port_and_path(any(), any()) :: nonempty_binary()
  def host_port_and_path(conn, path) do
    host_and_port(conn)
    |> prepend_to_path(path)
  end

  @spec host_and_port(any()) :: nonempty_binary()
  def host_and_port(conn) do
    conn.host <> ":" <> Integer.to_string(conn.port)
  end

  @spec prepend_to_path(any(), any()) :: nonempty_binary()
  def prepend_to_path(host_port, path) do
    "#{host_port}/#{path}"
  end
end
