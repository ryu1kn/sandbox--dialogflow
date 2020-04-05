from google.cloud import logging_v2

from conversation_history import parse

log_client = logging_v2.LoggingServiceV2Client()
resource_names = ["projects/sandbox--gcp"]
log_filter = """
logName = "projects/sandbox--gcp/logs/dialogflow_agent"
labels.type = "dialogflow_response"
timestamp >= "2020-04-05T00:00:00+11:00"
"""


def main():
    for entry in log_client.list_log_entries(resource_names, filter_=log_filter):
        response = entry.text_payload.replace('Dialogflow Response : ', '', 1)
        dialogflow_response = parse(response)['result']['fulfillment']['speech']
        print(f'Dialogflow response: {dialogflow_response}')


if __name__ == '__main__':
    main()
