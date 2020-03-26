const dialogflow = require('dialogflow');
const agentConfig = require('./agent-config')

const client = new dialogflow.v2.AgentsClient()

client.setAgent({agent: agentConfig})
  .then(responses => { console.log(responses[0]) })
  .catch(e => { console.error(e); process.exit(1) })
