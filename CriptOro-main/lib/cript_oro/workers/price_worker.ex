defmodule CriptOro.Workers.PriceWorker do
  use GenServer
  require Logger

  # Client API
  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @doc """
  Grafik için son 3 saatlik (180 dk) Binance verisini çeker.
  """
  def get_historical_data do
    url = "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1m&limit=180"
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Enum.map(fn [ts, open | _] -> [ts, String.to_float(open)] end)
      _ -> []
    end
  end

  # Server Callbacks
  @impl true
  def init(_state) do
    schedule_update()
    {:ok, %{btc: 0.0, gold: 2650.0}}
  end

  @impl true
  def handle_info(:update_prices, state) do
    new_btc = fetch_binance_price("BTCUSDT") || state.btc

    new_gold = fetch_binance_price("PAXGUSDT") || state.gold

    new_state = %{
      btc: new_btc,
      gold: new_gold #  ONS
    }

    Phoenix.PubSub.broadcast(CriptOro.PubSub, "market_prices", {:new_prices, new_state})

    schedule_update()
    {:noreply, new_state}
  end

  defp fetch_binance_price(symbol) do
    url = "https://api.binance.com/api/v3/ticker/price?symbol=#{symbol}"
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"price" => price}} -> String.to_float(price)
          _ -> nil
        end
      {:error, reason} ->
        Logger.error("Binance API Hatası (#{symbol}): #{inspect(reason)}")
        nil
      _ -> nil
    end
  end

  defp schedule_update, do: Process.send_after(self(), :update_prices, 2000)
end
