import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from argh import ArghParser, arg
import random
import matplotlib.pyplot as plt
import seaborn as sns


@arg("days")
@arg("--int-only", default=False)
@arg("--chart-type", default="")
def generate_df(days: int, int_only: bool = False, chart_type: str = ""):

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

    if chart_type:
        plt.figure(figsize=(10, 6))
        if chart_type == "scatter":

            # Scatter plot
            sns.scatterplot(
                x=df["Date"], y=df["Value"], color="blue", label="Data Points"
            )

            # Set titles and labels
            plt.title("Scatter Plot with Trend Line", fontsize=14)
            plt.xlabel("Date", fontsize=12)
            plt.ylabel("Value", fontsize=12)

        elif chart_type == "histogram":
            plt.hist(df["Value"], bins=4)
            plt.title("Histogram", fontsize=14)
            plt.ylabel("Count", fontsize=12)

        elif chart_type == "pie":
            # Define bins (quantile-based)
            df["binned"] = pd.qcut(
                df["Value"],
                q=5,
                labels=["Extreme fear", "Fear", "Neutral", "Greed", "Extreme greed"],
            )

            bin_counts = df["binned"].value_counts()
            bin_proportions = bin_counts / bin_counts.sum()

            # Create the pie chart
            plt.pie(bin_proportions, labels=bin_proportions.index, autopct="%1.1f%%")
            plt.title("Distribution of Values by Quantile")

        else:
            print(f"Invalid chart type: {chart_type}")
            return
        plt.legend()
        plt.show()


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([generate_df])
    parser.dispatch()
