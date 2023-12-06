import pandas as pd
import logging
from src.db.setup import db

logging.basicConfig(level=logging.INFO)


def insert_record(date, index):
    timestamp_gp = date.tz_localize("UTC").tz_convert("Europe/London")
    logging.info(
        f"Inserting record to database dated {timestamp_gp} with index {index}"
    )
    db["records"].insert_one({"index": str(index), "created": str(timestamp_gp)})
    logging.info(f"Saved record to database.")


def generate_df():
    date_cols = [
        "Date",
    ]
    return pd.read_csv(
        "./data/data.csv",
        sep="\t",
        header=0,
        parse_dates=date_cols,
        dayfirst=True,
    )


def update_db():
    logging.info("Updating database with CSV data...")
    df = generate_df()
    [insert_record(x, y) for x, y in zip(df["Date"], df["Index"])]


if __name__ == "__main__":
    update_db()
