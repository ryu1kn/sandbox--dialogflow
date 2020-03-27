const {google} = require('googleapis');
const {dialogflow} = require('actions-on-google');

const PEOPLE_SHEET_ID = '1Qzp74ZnEY0rGcnr37MBCQp8yq5jUbUcc6CPHj-hJTcA'
const PEOPLE_SHEET_RANGE = 'People!A2:B'

const app = dialogflow({debug: true})

console.log(`---> Read people data from ${sheetUrl(PEOPLE_SHEET_ID)}`)

app.intent('Greeting', async (conv, {name}) => {
  const people = await readSheet(await createAuth())
  const hobby = people
      .filter(([n]) => n === name)
      .map(([n, hobby]) => hobby)

  conv.close(`Hello ${name}! I heard you like ${hobby}!`)
})

function createAuth() {
  const auth = new google.auth.GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
  });
  return auth.getClient();
}

function sheetUrl(sheetId) {
  return `https://docs.google.com/spreadsheets/d/${sheetId}/view`;
}

async function readSheet(auth) {
  const sheets = google.sheets({version: 'v4', auth});
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: PEOPLE_SHEET_ID,
    range: PEOPLE_SHEET_RANGE
  });
  return res.data.values;
}

exports.handler = app
