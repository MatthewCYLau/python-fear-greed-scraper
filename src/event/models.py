import pytz
from datetime import datetime, timezone

GB = pytz.timezone("Europe/London")


class Event:
    def __init__(self, index, user_id, alert_id):
        self.index = index
        self.user_id = user_id
        self.alert_id = alert_id
        self.creatd = datetime.now(timezone.utc).astimezone(GB).isoformat()
