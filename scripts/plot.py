from datetime import datetime
from dateutil.relativedelta import relativedelta
from argh import ArghParser, arg
import matplotlib.pyplot as plt
import yfinance as yf
from sklearn.linear_model import LinearRegression


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

    # Set the target price
    target_price = 250
    # Plot the target price as a horizontal line
    plt.axhline(
        y=target_price,
        color="r",
        linestyle="--",
        label=f"Target Price: ${target_price}",
    )

    if len(tickers_list) == 1:
        x = data.index
        y = data.values.reshape(-1, 1)

        lm = LinearRegression()
        lm.fit(x.values.reshape(-1, 1), y)

        predictions = lm.predict(x.values.astype(float).reshape(-1, 1))
        plt.plot(x, predictions, label="Linear fit", lw=3, color="red")

        ticker = tickers_list[0]
        rolling_avg = data[ticker].rolling(window=100).mean()
        current_price = data[ticker].iloc[-1]
        current_rolling_avg = rolling_avg.iloc[-1]
        print(f"{ticker} current price: {current_price:.2f}")
        print(f"{ticker} current 100-day rolling average: {current_rolling_avg:.2f}")

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
