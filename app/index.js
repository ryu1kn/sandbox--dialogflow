const {google} = require('googleapis');

async function main() {
  const sheet = {
    id: process.argv[2],
    range: process.argv[3]
  };
  console.log(`---> Accessing ${sheetUrl(sheet.id)}\n`);
  printRange(await createAuth(), sheet);
}

function createAuth() {
  const auth = new google.auth.GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
  });
  return auth.getClient();
}

function sheetUrl(sheetId) {
  return `https://docs.google.com/spreadsheets/d/${sheetId}/view`;
}

async function printRange(auth, sheet) {
  const sheets = google.sheets({version: 'v4', auth});
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: sheet.id,
    range: sheet.range,
  });

  const rows = res.data.values;
  rows.map((row) => {
    console.log(row.join(', '))
  });
}

main().catch(e => console.error(e.stack));
