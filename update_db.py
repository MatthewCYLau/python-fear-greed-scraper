import pandas as pd
import logging
from argh import ArghParser, arg

# from src.db.setup import db

logging.basicConfig(level=logging.INFO)


def insert_record(date, index):
    timestamp_gp = date.tz_localize("UTC").tz_convert("Europe/London")
    logging.info(
        f"Inserting record to database dated {timestamp_gp} with index {index}"
    )
    # db["records"].insert_one({"index": str(index), "created": str(timestamp_gp)})
    logging.info(f"Saved record to database.")


def generate_df(csv_file_path: str | None = ""):
    date_cols = [
        "Date",
    ]
    return pd.read_csv(
        csv_file_path,
        sep="\t",
        header=0,
        parse_dates=date_cols,
        dayfirst=True,
    )


@arg("count")
@arg("--copy", default="")
def update_db(count, copy: str = ""):
    logging.info(f"Updating database with {count} CSV data {copy}...")
    df_1 = generate_df("./data/data.csv")
    [insert_record(x, y) for x, y in zip(df_1["Date"], df_1["Index"])]

    # merge second dataframe from CSV
    df_2 = generate_df("./data/data2.csv")
    merged_df = pd.merge(df_1, df_2, on="Date", how="inner")
    merged_df = merged_df.set_index("Date")
    print(merged_df)


if __name__ == "__main__":
    parser = ArghParser()
    parser.add_commands([update_db])
    parser.dispatch()
