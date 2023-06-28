import pytz
from datetime import datetime, timezone

GB = pytz.timezone("Europe/London")


class Event:
    def __init__(self, index, alert_id):
        self.index = index
        self.alert_id = alert_id
        self.created = datetime.now(timezone.utc).astimezone(GB).isoformat()
