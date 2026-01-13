defmodule CriptOro.Workers.CurrencyWorker do
  use GenServer
  require Logger

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(_) do
    send(self(), :fetch_rates)
    {:ok, %{try_rate: 36.30, eur_usd_rate: 1.08}}
  end

  def get_rates, do: GenServer.call(__MODULE__, :get_rates)

  def handle_call(:get_rates, _from, state), do: {:reply, state, state}

  def handle_info(:fetch_rates, _state) do
    # Binance
    new_state = %{
      try_rate: fetch_binance_price("USDTTRY") || 36.30,
      eur_usd_rate: fetch_binance_price("EURUSDT") || 1.08 # 1 Euro to Dolar
    }

    Logger.info("Kurlar Güncellendi -> USD/TRY: #{new_state.try_rate}, EUR/USD: #{new_state.eur_usd_rate}")

    Process.send_after(self(), :fetch_rates, :timer.minutes(5))
    {:noreply, new_state}
  end

  defp fetch_binance_price(symbol) do
    url = "https://api.binance.com/api/v3/ticker/price?symbol=#{symbol}"
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode!(body)["price"] |> String.to_float()
      _ -> nil
    end
  end
end
