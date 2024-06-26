from datetime import datetime, timezone
from src.db.setup import db
import logging


class Event:
    def __init__(self, index, alert_id):
        self.index = index
        self.alert_id = alert_id
        self.acknowledged = False
        self.created = datetime.now(tz=timezone.utc)

    def save_to_database(self):
        db["events"].insert_one(vars(self))
        logging.info(f"Saved event to database - {self.index} {self.alert_id}")
