# Create Agent

Creates a Dialogflow agent with intents/response already imported.

## Usage

Create an agent config file as `config.js` in the same directory, then:

```sh
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
node create-agent
```

## References

* [`setAgent` - Dialogflow API: Node.js Client](https://googleapis.dev/nodejs/dialogflow/latest/v2.AgentsClient.html#setAgent)
