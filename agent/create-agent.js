const dialogflow = require('dialogflow')
const {promisify} = require('util')
const fs = require('fs').promises
const fsExtra = require('fs-extra')
const zipFolder = promisify(require('zip-folder'))
const agentConfig = require('./agent-config')

const client = new dialogflow.v2.AgentsClient()

const main = async () => {
  await buildAgentDefiniton()
  await zipFolder(dehydratedPath(), '__agent.zip')
  await importAgent()
}

const buildAgentDefiniton = async () => {
  await fsExtra.copy(templatePath('intents'), dehydratedPath('intents'))
  await fsExtra.copy(templatePath('package.json'), dehydratedPath('package.json'))
  const agentText = await fs.readFile(templatePath('agent.json'), 'utf8')
  const dehydratedAgentText = agentText
      .replace('__WEBHOOK_URL__', 'https://asia-east2-sandbox--gcp.cloudfunctions.net/my-function')
      .replace('__WEBHOOK_AUTH_HEADER__', 'Basic password')
  await fs.writeFile(dehydratedPath('agent.json'), dehydratedAgentText, 'utf8')
}

const templatePath = path => `${__dirname}/agent-template/${path}`
const dehydratedPath = path => `${__dirname}/__agent` + (path ? `/${path}` : '')

const importAgent = async () => {
  await client.setAgent({agent: agentConfig})

  const agentParams = {
    parent: client.projectPath('sandbox--gcp'),
    agentContent: await fs.readFile('__agent.zip')
  }
  const [operation] = await client.importAgent(agentParams)
  await operation.promise()
}

main().then(result => { console.log(result) })
  .catch(e => { console.error(e); process.exit(1) })
