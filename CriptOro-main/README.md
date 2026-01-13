# CriptOro 🪙🚀

CriptOro is a high-performance, real-time cryptocurrency and precious metals dashboard built with **Elixir** and **Phoenix LiveView**. It bridges the gap between digital assets and traditional stores of value by tracking market fluctuations second-by-second.

The name **CriptOro** is a fusion of **Cripto** (modern decentralized finance) and **Oro** (Spanish/Italian for *Gold*), representing a unified approach to wealth management.

---

## ✨ Features

- **Real-Time Data Streaming**: Live BTC and Gold (PAXG) prices streaming directly from the Binance API via WebSockets.
- **Smart Currency Conversion**: Automatic real-time conversion to **USD**, **TRY**, and **EUR** using live market parities (USDT/TRY and EUR/USD).
- **Interactive Live Charting**: High-performance historical trend visualization (last 3 hours) using **ApexCharts** and Phoenix Hooks with optimized data sampling.
- **Instant Portfolio Calculator**: Real-time valuation of your BTC and Gold holdings without any page refresh, featuring safe float parsing.
- **High Availability**: Built on Elixir's **GenServer** and **PubSub** architecture for a fault-tolerant, resilient data pipeline.

---

## 🛠 Tech Stack

- **Backend**: [Elixir](https://elixir-lang.org/) & [Phoenix Framework (LiveView)](https://www.phoenixframework.org/)
- **Frontend**: [Tailwind CSS](https://tailwindcss.com/), [ApexCharts](https://apexcharts.com/)
- **Real-time Engine**: Phoenix PubSub & JS Hooks
- **Data Source**: Binance API (Spot & Market Tickers)

## 🚀 Getting Started

To get CriptOro running locally:

1. **Clone the repository**:
   ```bash
   git clone git@github.com:yusuf-ozcan/CriptOro.git
   cd cript_oro
   ```
2. **Install dependencies**:
   ```bash
   mix deps.get
   cd assets && npm install && cd ..
   ```
3. **Start Phoenix server**:
   ```bash
   mix phx.server
   ```
4. **Access the dashboard**: Visit localhost:4000 in your browser.

---

## 📈 Dashboard Preview
The dashboard features a real-time area chart showing BTC/USD trends over the last 3 hours, along with live cards for TRY and EUR conversions.

---

## 🚧 Roadmap
[x] Live Gold (PAXG) price integration.

[x] Real-time EUR and TRY currency conversion via Binance parities.

[x] Optimized 3-hour historical trend chart with load-history support.

[ ] Database Integration (Ecto): Persist user portfolio amounts across sessions.

[ ] Multi-Asset Support: Support for ETH, SOL, and other major commodities.

[ ] Price Alerts: Real-time notifications for specific market targets.

---

## 📄 License
This project is open-source and available under the MIT License.


   
