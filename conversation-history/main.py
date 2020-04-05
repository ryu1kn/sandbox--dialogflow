from google.cloud import logging_v2

from config import read
from conversation_history import parse
from datetime import datetime, timezone, timedelta

log_client = logging_v2.LoggingServiceV2Client()
melb_time_offset = timezone(timedelta(seconds=10 * 60 * 60))


def make_filter(project_id, days_ago):
    start_date = datetime.now(melb_time_offset) - timedelta(days=days_ago)
    return f"""\
        logName = "projects/{project_id}/logs/dialogflow_agent"
        labels.type = "dialogflow_response"
        timestamp >= "{start_date.isoformat(timespec='milliseconds')}"
        """


def main():
    config = read()
    resource_names = [f"projects/{config['project_id']}"]
    filter_conditions = make_filter(config['project_id'], config['fetch_days_ago'])

    for entry in log_client.list_log_entries(resource_names, filter_=filter_conditions):
        response = entry.text_payload.replace('Dialogflow Response : ', '', 1)
        dialogflow_response = parse(response)['result']['fulfillment']['speech']
        print(f'Dialogflow response: {dialogflow_response}')


if __name__ == '__main__':
    main()
