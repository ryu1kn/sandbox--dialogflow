import sys

from conversation_history import parse


def main(log_entry_file):
    f = open(log_entry_file, 'r')
    dialogflow_response = parse(f.read())['result']['fulfillment']['speech']
    print(f'Dialogflow response: {dialogflow_response}')


if __name__ == '__main__':
    main(sys.argv[1])
