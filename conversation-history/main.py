from google.cloud import logging_v2

from config import read
from conversation_history import parse

log_client = logging_v2.LoggingServiceV2Client()


def make_filter(project_id):
    return f"""\
        logName = "projects/{project_id}/logs/dialogflow_agent"
        labels.type = "dialogflow_response"
        timestamp >= "2020-04-05T00:00:00+11:00"
        """


def main():
    project_id = read()['project_id']
    resource_names = [f"projects/{project_id}"]

    for entry in log_client.list_log_entries(resource_names, filter_=make_filter(project_id)):
        response = entry.text_payload.replace('Dialogflow Response : ', '', 1)
        dialogflow_response = parse(response)['result']['fulfillment']['speech']
        print(f'Dialogflow response: {dialogflow_response}')


if __name__ == '__main__':
    main()
