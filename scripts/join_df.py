from argh import ArghParser, arg
import matplotlib.pyplot as plt
import yfinance as yf


@arg("--stocks", default="")
def join_dfs(stocks: str = ""):

    tickers_list = stocks.split(";")
    first_stock = tickers_list[0]
    second_stock = tickers_list[1]
    data = yf.Ticker(first_stock)
    df1 = data.history(period="1y")

    data = yf.Ticker(second_stock)
    df2 = data.history(period="1y")

    joined_df = df1.join(df2, how="inner", lsuffix=first_stock, rsuffix=second_stock)[
        [f"Close{first_stock}", f"Close{second_stock}"]
    ]
    print(joined_df)
    joined_df.plot(figsize=(10, 7))

    plt.legend()
    plt.title("Stock Charts Plot", fontsize=16)

    # Define the labels
    plt.ylabel("Close", fontsize=14)
    plt.xlabel("Time", fontsize=14)

    # Plot the grid lines
    plt.grid(which="major", color="k", linestyle="-.", linewidth=0.5)

    plt.show()


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([join_dfs])
    parser.dispatch()
