const {readFileSync} = require('fs')

const projectConfig = JSON.parse(readFileSync(`${__dirname}/../config.json`, 'utf8'))
const encryptedWebhookAuthKey = readFileSync(`${__dirname}/../secrets/auth-key.enc.txt`, 'utf8').trim()

module.exports = {
  ...projectConfig,
  encryptedWebhookAuthKey,
  agent: {
    parent: 'projects/sandbox--gcp',
    displayName: 'foobar',
    defaultLanguageCode: 'en',
    timeZone: 'Australia/Sydney'
  }
}
