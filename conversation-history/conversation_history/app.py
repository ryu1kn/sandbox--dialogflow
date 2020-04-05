import csv
from conversation_history import parse


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
