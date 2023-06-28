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
