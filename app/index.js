const {google} = require('googleapis');
const {dialogflow} = require('actions-on-google');

const PEOPLE_SHEET_ID = '1Qzp74ZnEY0rGcnr37MBCQp8yq5jUbUcc6CPHj-hJTcA'
const PEOPLE_SHEET_RANGE = 'People!A2:B'
const KMS_KEY_REGION = process.env.KMS_KEY_REGION;
const KMS_KEY_PROJECT = process.env.KMS_KEY_PROJECT;
const KMS_KEY_RING = process.env.KMS_KEY_RING;
const KMS_KEY_NAME = process.env.KMS_KEY_NAME;

const app = dialogflow({debug: true})
const cloudKms = google.cloudkms({version: 'v1'}).projects.locations.keyRings.cryptoKeys

const info = (...args) => { console.info('---> ', args.map(v => v.toString()).join(' ')) }

info('Read people data from', sheetUrl(PEOPLE_SHEET_ID))

const authSdk = async () => {
  google.options({
    auth: await createAuth()
  })
}

const authKey = async () => {
  const result = await cloudKms.decrypt({
    name: `projects/${KMS_KEY_PROJECT}/locations/${KMS_KEY_REGION}/keyRings/${KMS_KEY_RING}/cryptoKeys/${KMS_KEY_NAME}`,
    requestBody: {ciphertext: process.env.ENCRYPTED_AUTH_KEY}
  })
  return Buffer.from(result.data.plaintext, 'base64').toString('utf8')
}

const extractApiKey = req => req.get('Authorization').replace(/^Basic /, '')

app.intent('Greeting', async (conv, {name}) => {
  const people = await readSheet()
  const hobby = people
      .filter(([n]) => n === name)
      .map(([n, hobby]) => hobby)
  if (hobby.length !== 0)
    conv.close(`Hello ${name}! I heard you like ${hobby[0]}!`)
  else
    conv.close(`Hello ${name}! I like chatting!`)
})

function createAuth() {
  const auth = new google.auth.GoogleAuth({
    scopes: [
      'https://www.googleapis.com/auth/spreadsheets.readonly',
      'https://www.googleapis.com/auth/cloudkms'
    ]
  });
  return auth.getClient();
}

function sheetUrl(sheetId) {
  return `https://docs.google.com/spreadsheets/d/${sheetId}/view`;
}

async function readSheet() {
  const sheets = google.sheets({version: 'v4'});
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: PEOPLE_SHEET_ID,
    range: PEOPLE_SHEET_RANGE
  });
  return res.data.values;
}

exports.handler = async (req, res) => {
  try {
    await authSdk()
    if (extractApiKey(req) === await authKey()) {
      app(req, res)
    } else {
      res.status(403).send('Not authorised')
    }
  } catch (e) {
    console.error(e.stack)
    res.status(500).send(e.stack)
  }
}
