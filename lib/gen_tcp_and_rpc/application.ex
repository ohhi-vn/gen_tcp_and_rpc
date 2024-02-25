defmodule GenTcpAndRpc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GenTcpAndRpc.Worker.start_link(arg)
      # {GenTcpAndRpc.Worker, arg}
      %{id: GenTcpAndRpc.Server, start: {GenTcpAndRpc.Server, :start_link, [[]]}},
      %{id: GenTcpAndRpc.Client, start: {GenTcpAndRpc.Client, :start_link, [[]]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenTcpAndRpc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
