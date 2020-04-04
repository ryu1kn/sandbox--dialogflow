import sys
import os

from conversation_history import parse


def log_entry_file():
    return sys.argv[1] if len(sys.argv) > 1 else f'{os.path.dirname(__file__)}/sample-log-entry.txt'


def main():
    f = open(log_entry_file(), 'r')
    dialogflow_response = parse(f.read())['result']['fulfillment']['speech']
    print(f'Dialogflow response: {dialogflow_response}')


if __name__ == '__main__':
    main()
