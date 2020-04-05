import csv
from datetime import datetime, timezone, timedelta

from google.cloud import logging_v2

from config import read
from conversation_history import parse

log_client = logging_v2.LoggingServiceV2Client()
melb_time_offset = timezone(timedelta(seconds=10 * 60 * 60))


def make_filter(project_id, days_ago):
    start_date = datetime.now(melb_time_offset) - timedelta(days=days_ago)
    return f"""\
        logName = "projects/{project_id}/logs/dialogflow_agent"
        labels.type = "dialogflow_response"
        timestamp >= "{start_date.isoformat(timespec='milliseconds')}"
        """


class App:
    def __init__(self, read_log_entries, csv_file):
        self.read_log_entries = read_log_entries
        self.csv_file = csv_file

    def run(self):
        with open(self.csv_file, 'w', newline='') as csvfile:
            fieldnames = ['timestamp', 'score', 'intent_name', 'speech']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()

            for entry in self.read_log_entries():
                response = parse(entry.text_payload.replace('Dialogflow Response : ', '', 1))
                writer.writerow({
                    'timestamp': response['timestamp'],
                    'intent_name': response['result']['metadata']['intent_name'],
                    'speech': response['result']['fulfillment']['speech'],
                    'score': response['result']['score']
                })


def main():
    config = read()
    resource_names = [f"projects/{config['project_id']}"]
    filter_conditions = make_filter(config['project_id'], config['fetch_days_ago'])

    read_log_entries = lambda: log_client.list_log_entries(resource_names, filter_=filter_conditions)
    App(read_log_entries, config['output_csv_file']).run()


if __name__ == '__main__':
    main()
