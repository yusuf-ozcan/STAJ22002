defmodule CriptOroWeb.DashboardLive do
  use CriptOroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(CriptOro.PubSub, "market_prices")

      # Binance data
      historical_data = CriptOro.Workers.PriceWorker.get_historical_data()
      send(self(), {:load_history, historical_data})
    end

    {:ok,
     assign(socket,
       btc_price: 0.0,
       gold_price: 0.0,
       btc_try: 0.0,
       btc_eur: 0.0,
       my_btc: 0.0,
       my_gold: 0.0,
       total_value: 0.0,
       total_value_try: 0.0,
       total_value_eur: 0.0,
       last_chart_update: 0
     )}
  end

  @impl true
  def handle_info({:load_history, data}, socket) do
    {:noreply, push_event(socket, "load-history", %{points: data})}
  end

  @impl true
  def handle_info({:new_prices, prices}, socket) do
    rates = CriptOro.Workers.CurrencyWorker.get_rates()
    current_time = System.system_time(:millisecond)

    btc_usd = prices.btc

    btc_try = btc_usd * rates.try_rate
    btc_eur = btc_usd / rates.eur_usd_rate

    total_usd = (socket.assigns.my_btc * btc_usd) + (socket.assigns.my_gold * prices.gold)

    socket =
      if current_time - socket.assigns.last_chart_update >= 5000 do
        socket
        |> push_event("new-point", %{
          x: current_time,
          y: Float.round(btc_usd, 2)
        })
        |> assign(last_chart_update: current_time)
      else
        socket
      end

    {:noreply,
     assign(socket,
       btc_price: btc_usd,
       gold_price: prices.gold,
       btc_try: btc_try,
       btc_eur: btc_eur,
       total_value: total_usd,
       total_value_try: total_usd * rates.try_rate,
       total_value_eur: total_usd / rates.eur_usd_rate
     )}
  end

  @impl true
  def handle_event("calculate", %{"btc_amount" => btc, "gold_amount" => gold}, socket) do
    btc_float = parse_float(btc)
    gold_float = parse_float(gold)
    rates = CriptOro.Workers.CurrencyWorker.get_rates()

    total_usd = (btc_float * socket.assigns.btc_price) + (gold_float * socket.assigns.gold_price)

    {:noreply,
     assign(socket,
       my_btc: btc_float,
       my_gold: gold_float,
       total_value: total_usd,
       total_value_try: total_usd * rates.try_rate,
       total_value_eur: total_usd / rates.eur_usd_rate
     )}
  end

  defp parse_float(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-8 max-w-6xl mx-auto bg-white shadow-2xl rounded-3xl mt-10 border border-gray-100">
      <h1 class="text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-yellow-500 to-orange-600 mb-10 text-center uppercase tracking-tighter">
        CriptOro Global
      </h1>

      <%!-- CANLI FİYATLAR --%>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="p-6 bg-slate-900 text-white rounded-2xl border-b-4 border-orange-500 shadow-lg transition-all hover:scale-105">
          <span class="block text-xs uppercase tracking-widest text-slate-400 mb-1 font-bold text-center italic">BTC / USD</span>
          <span class="block text-3xl font-mono font-bold text-orange-400 text-center">
            $<%= :erlang.float_to_binary(@btc_price, [decimals: 2]) %>
          </span>
        </div>

        <div class="p-6 bg-slate-900 text-white rounded-2xl border-b-4 border-blue-500 shadow-lg transition-all hover:scale-105">
          <span class="block text-xs uppercase tracking-widest text-slate-400 mb-1 font-bold text-center italic">BTC / TRY</span>
          <span class="block text-3xl font-mono font-bold text-blue-400 text-center">
            ₺<%= :erlang.float_to_binary(@btc_try, [decimals: 2]) %>
          </span>
        </div>

        <div class="p-6 bg-slate-900 text-white rounded-2xl border-b-4 border-green-500 shadow-lg transition-all hover:scale-105">
          <span class="block text-xs uppercase tracking-widest text-slate-400 mb-1 font-bold text-center italic">BTC / EUR</span>
          <span class="block text-3xl font-mono font-bold text-green-400 text-center">
            €<%= :erlang.float_to_binary(@btc_eur, [decimals: 2]) %>
          </span>
        </div>
      </div>

      <%!-- CHART --%>
      <div class="mb-12 p-4 bg-white rounded-2xl border border-gray-200 shadow-sm relative overflow-hidden">
        <div class="absolute top-4 right-6 flex items-center gap-2">
          <span class="w-2 h-2 bg-green-500 rounded-full animate-ping"></span>
          <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest">Market Live</span>
        </div>
        <h3 class="text-gray-500 text-sm font-bold mb-4 uppercase ml-2 text-center">Live Market Trend</h3>
        <div id="chart-container" phx-update="ignore" phx-hook="LineChart" class="w-full h-64"></div>
      </div>

      <%!-- CALCULATOR --%>
      <div class="bg-gray-100 p-8 rounded-2xl border border-gray-300 shadow-inner">
        <h2 class="text-2xl font-bold mb-6 text-slate-800 text-center uppercase tracking-widest">Portfolio Analytics</h2>

        <form phx-change="calculate" class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="text-center group">
            <label class="block text-sm font-bold text-slate-700 mb-2 uppercase tracking-wide">My BTC Amount</label>
            <input type="number" name="btc_amount" step="0.0001" value={@my_btc}
                   class="w-full p-4 rounded-xl border-2 border-gray-300 text-black bg-white font-bold focus:ring-4 focus:ring-orange-100 focus:border-orange-500 text-center transition-all" />
          </div>

          <div class="text-center group">
            <label class="block text-sm font-bold text-slate-700 mb-2 uppercase tracking-wide">My Gold Amount (Oz)</label>
            <input type="number" name="gold_amount" step="0.01" value={@my_gold}
                   class="w-full p-4 rounded-xl border-2 border-gray-300 text-black bg-white font-bold focus:ring-4 focus:ring-yellow-500/10 focus:border-yellow-500 text-center transition-all" />
          </div>
        </form>

        <%!-- BALANCES --%>
        <div class="mt-10 pt-8 border-t-2 border-gray-300 text-center">
          <p class="text-sm text-slate-500 mb-1 font-bold uppercase tracking-[0.2em]">Net Worth (USD Base)</p>
          <p class="text-7xl font-black text-green-600 mb-8 tracking-tighter">
            $<%= :erlang.float_to_binary(@total_value, [decimals: 2]) %>
          </p>

          <div class="grid grid-cols-2 gap-8 max-w-2xl mx-auto border-t border-dashed border-gray-400 pt-8">
            <div class="flex flex-col items-center">
              <span class="text-xs text-gray-400 uppercase font-black mb-2 tracking-widest italic">Lira Balance</span>
              <span class="text-slate-800 font-mono text-4xl font-bold italic">₺ <%= :erlang.float_to_binary(@total_value_try, [decimals: 2]) %></span>
            </div>
            <div class="flex flex-col items-center border-l-2 border-gray-200 pl-8">
              <span class="text-xs text-gray-400 uppercase font-black mb-2 tracking-widest italic">Euro Balance</span>
              <span class="text-slate-800 font-mono text-4xl font-bold italic">€ <%= :erlang.float_to_binary(@total_value_eur, [decimals: 2]) %></span>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
