defmodule GenTcpAndRpc.Client do
  use GenServer
  require Logger

  @port 8080
  @host :localhost

  ## API
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{socket: nil}, name: :tcp_client)
  end

  ## Callback
  @impl true
  def init(state) do
    Logger.info "Client: connecting to #{@host}"

    case :gen_tcp.connect(@host, @port, [:binary, packet: :line, active: true]) do
      {:ok, socket} ->
        Logger.info "Client: connected successfully to #{@host} !"
        {:ok, %{state | socket: socket}}
      {:error, reason} ->
        disconnect(state, reason)
    end
  end

  @impl true
  def handle_info(:terminate, state) do
    Logger.info("Client: received terminate message.")
    {:noreply, state}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def terminate(_reason, _) do
    :ok
  end

  defp disconnect(state, reason) do
    Logger.info "Client: disconnected: #{reason}"
    {:stop, :normal, state}
  end

end
