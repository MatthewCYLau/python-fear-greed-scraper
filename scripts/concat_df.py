from argh import ArghParser, arg
import pandas as pd
import yfinance as yf


def double_value(n):
    return n * 2


@arg("--stocks", default="")
def concat_dfs(stocks: str = ""):

    tickers_list = stocks.split(";")
    first_stock = tickers_list[0]
    second_stock = tickers_list[1]
    data = yf.Ticker(first_stock)
    df1 = data.history(period="1mo")
    df1["Stock"] = first_stock
    df1 = df1[["Stock", "Close"]]

    data = yf.Ticker(second_stock)
    df2 = data.history(period="1mo")
    df2["Stock"] = second_stock
    df2 = df2[["Stock", "Close"]]

    concat_df = pd.concat([df1, df2])
    concat_df["Double Close"] = concat_df["Close"].map(double_value)

    print(concat_df)


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([concat_dfs])
    parser.dispatch()
