import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from argh import ArghParser, arg
import random
import matplotlib.pyplot as plt
import seaborn as sns


@arg("days")
@arg("--int-only", default=False)
@arg("--plot", default=False)
def generate_df(days: int, int_only: bool = False, plot: bool = False):

    days = int(days)
    dates = pd.date_range(
        (datetime.today() - timedelta(days=days)).strftime("%Y-%m-%d"), periods=days
    )
    if int_only:
        values = np.random.randint(1, 100, size=days)
    else:
        values = [round(random.uniform(1, 100), 2) for _ in range(days)]
    df = pd.DataFrame({"Date": dates, "Value": values})
    print(df)

    if plot:
        plt.figure(figsize=(10, 6))

        # Scatter plot
        sns.scatterplot(x=df["Date"], y=df["Value"], color="blue", label="Data Points")

        # Set titles and labels
        plt.title("Scatter Plot with Trend Line", fontsize=14)
        plt.xlabel("Date", fontsize=12)
        plt.ylabel("Value", fontsize=12)

        # Show the plot
        plt.legend()
        plt.show()


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([generate_df])
    parser.dispatch()
