import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from argh import ArghParser, arg
import random


@arg("--days", default=0)
@arg("--int-only", default=False)
def generate_df(days: int = 0, int_only: bool = False):

    dates = pd.date_range(
        (datetime.today() - timedelta(days=days)).strftime("%Y-%m-%d"), periods=days
    )
    if int_only:
        values = np.random.randint(1, 100, size=days)
    else:
        values = [round(random.uniform(1, 100), 2) for _ in range(days)]
    df = pd.DataFrame({"Date": dates, "Value": values})
    print(df)


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([generate_df])
    parser.dispatch()
