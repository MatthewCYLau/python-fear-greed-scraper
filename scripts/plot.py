from datetime import datetime
from dateutil.relativedelta import relativedelta
from argh import ArghParser, arg
import matplotlib.pyplot as plt
import yfinance as yf


@arg("--stocks", default="")
@arg("--cumulative_returns", default=False)
def plot_stocks_charts(stocks: str = "", cumulative_returns: bool = False):

    tickers_list = stocks.split(";")
    today = datetime.today()

    one_year_ago = today - relativedelta(years=1)
    formatted_date = one_year_ago.strftime("%Y-%m-%d")
    data = yf.download(tickers_list, formatted_date)["Adj Close"]

    y_label = "Close Value"
    # Plot all the close prices
    if cumulative_returns:
        ((data.pct_change() + 1).cumprod()).plot(figsize=(10, 7))
        y_label = "Cumulative " + y_label
    else:
        data.plot(figsize=(10, 7))
    plt.legend()
    plt.title("Stock Charts Plot", fontsize=16)

    # Define the labels
    plt.ylabel(y_label, fontsize=14)
    plt.xlabel("Time", fontsize=14)

    # Plot the grid lines
    plt.grid(which="major", color="k", linestyle="-.", linewidth=0.5)
    plt.show()


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([plot_stocks_charts])
    parser.dispatch()
