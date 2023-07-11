import pytz
import logging
from datetime import datetime, timezone
from src.db.setup import db

GB = pytz.timezone("Europe/London")


class Record:
    def __init__(self, index):
        self.index = index
        self.created = datetime.now(timezone.utc).astimezone(GB).isoformat()

    def save_to_database(self):
        db["records"].insert_one(vars(self))
        logging.info(f"Saved record to database - {self.index}")

    @staticmethod
    def check_if_record_already_created_for_today():
        previous_records = list(
            db["records"].find(
                {"created": {"$gte": datetime.today().strftime("%Y-%m-%d")}}
            )
        )
        if previous_records:
            logging.info(
                f"Records found for today's date - count of records: {len(previous_records)}"
            )
            return True
        else:
            logging.info("No record found for today's date")
            return False
