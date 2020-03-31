const {readFileSync} = require('fs')

const projectConfig = JSON.parse(readFileSync(`${__dirname}/../config.json`, 'utf8'))

module.exports = {
  ...projectConfig,
  agent: {
    parent: 'projects/sandbox--gcp',
    displayName: 'foobar',
    defaultLanguageCode: 'en',
    timeZone: 'Australia/Sydney'
  }
}
