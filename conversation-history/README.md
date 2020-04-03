# Conversation History

Google Dialogflow does not provide an API to fetch conversation history (See [this][1]).

The conversation history can be retrieved from GCP Stackdriver log,
but Dialogflow logs them as JSON-like text but not JSON.

This code here is to attempt to parse the log and restore the structured data from the log.

## Prerequisites

* `virtualenv`
* `poetry`

## Workspace setup

```sh
virtualenv venv     # This directory is git-ignored
. venv/bin/activate
poetry install
```

## Usage

```sh
python main.py sample-log-entry.txt
```

## References

* [Dialogflow V2 API](https://googleapis.dev/nodejs/dialogflow/latest/v2.AgentsClient.html)
* [Lark - A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface](https://github.com/lark-parser/lark)
* [Lark Tutorial - JSON parser](https://github.com/lark-parser/lark/blob/7a13fb0f5b968046795fa9d221a38c2a34503605/docs/json_tutorial.md)
* [`lark/grammars/common.lark`](https://github.com/lark-parser/lark/blob/d2f55fe3ba7b4bbc95ecdce2c06347cf2314ca4e/lark/grammars/common.lark)

[1]: https://stackoverflow.com/questions/55377439/is-there-a-way-to-retrieve-the-conversation-history-in-dialogflow
