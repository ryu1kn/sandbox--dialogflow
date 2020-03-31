const dialogflow = require('dialogflow')
const {promisify} = require('util')
const fs = require('fs').promises
const fsExtra = require('fs-extra')
const kms = require('@google-cloud/kms')
const zipFolder = promisify(require('zip-folder'))
const config = require('./config')

const kmsClient = new kms.KeyManagementServiceClient()
const dialogflowClient = new dialogflow.v2.AgentsClient()

const main = async () => {
  const webhookAuthKey = await decrypt(config.encrypted_webhook_auth_key)
  await buildAgentDefiniton(process.env.WEBHOOK_URL, webhookAuthKey)
  await zipFolder(dehydratedPath(), '__agent.zip')
  await importAgent()
}

const decrypt = async cipherText => {
  const keyPath = kmsClient.cryptoKeyPath(config.project_id, config.region, config.kms_key_ring, config.kms_key_name)
  const [result] = await kmsClient.decrypt({name: keyPath, ciphertext: cipherText})
  return decodeBase64(result.plaintext)
}

const decodeBase64 = base64String =>
    Buffer.from(base64String, 'base64').toString('utf8')

const buildAgentDefiniton = async (webhookUrl, webhookAuthKey) => {
  await fsExtra.copy(templatePath('intents'), dehydratedPath('intents'))
  await fsExtra.copy(templatePath('package.json'), dehydratedPath('package.json'))
  const agentText = await fs.readFile(templatePath('agent.json'), 'utf8')
  const dehydratedAgentText = agentText
      .replace('__WEBHOOK_URL__', webhookUrl)
      .replace('__WEBHOOK_AUTH_HEADER__', `Basic ${webhookAuthKey}`)
  await fs.writeFile(dehydratedPath('agent.json'), dehydratedAgentText, 'utf8')
}

const templatePath = path => `${__dirname}/agent-template/${path}`
const dehydratedPath = path => `${__dirname}/__agent` + (path ? `/${path}` : '')

const importAgent = async () => {
  await dialogflowClient.setAgent({agent: config.agent})

  const agentParams = {
    parent: dialogflowClient.projectPath('sandbox--gcp'),
    agentContent: await fs.readFile('__agent.zip')
  }
  const [operation] = await dialogflowClient.importAgent(agentParams)
  await operation.promise()
}

main().catch(e => { setTimeout(() => { throw e }, 0) })
