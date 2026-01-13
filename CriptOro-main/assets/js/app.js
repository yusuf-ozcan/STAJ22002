// assets/js/app.js

import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import ApexCharts from "apexcharts"

let Hooks = {}

Hooks.LineChart = {
  mounted() {
    this.chartData = [];

    const options = {
      series: [{ name: "BTC/USD", data: [] }],
      chart: {
        type: 'area', 
        height: 350,
        animations: { enabled: false }, 
        toolbar: { show: false },
        zoom: { enabled: false },
        background: 'transparent'
      },
      dataLabels: { enabled: false }, 
      markers: { size: 0 },           
      stroke: { curve: 'smooth', width: 2 },
      
      fill: {
        type: 'gradient',
        gradient: {
          shadeIntensity: 1,
          opacityFrom: 0.45,
          opacityTo: 0.05,
          stops: [50, 100]
        }
      },
      colors: ['#F59E0B'], // Bitcoin colour 
      xaxis: {
        type: 'datetime',
        range: 10800000, 
        labels: { 
          datetimeUTC: false,
          style: { colors: '#64748b' }
        },
        axisBorder: { show: false }
      },
      yaxis: {
        labels: { 
          style: { colors: '#64748b' },
          formatter: (val) => "$" + val.toLocaleString() 
        }
      },
      grid: {
        borderColor: '#f1f5f9',
        strokeDashArray: 4
      },
      tooltip: {
        x: { format: 'HH:mm' },
        theme: 'light'
      }
    };

    this.chart = new ApexCharts(this.el, options);
    this.chart.render();

    this.handleEvent("load-history", ({ points }) => {
      this.chartData = points;
      this.chart.updateSeries([{ data: this.chartData }]);
    });

    this.handleEvent("new-point", ({ x, y }) => {
      this.chartData.push([x, y]);
      
      if (this.chartData.length > 1000) {
        this.chartData.shift();
      }

      this.chart.updateSeries([{ data: this.chartData }], false);
    });
  }
}


const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

topbar.config({ barColors: { 0: "#F59E0B" } })
window.addEventListener("phx:page-loading-start", () => topbar.show(300))
window.addEventListener("phx:page-loading-stop", () => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket