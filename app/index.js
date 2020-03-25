const {google} = require('googleapis');

async function main(req) {
  const sheet = {
    id: req.query.sheetId,
    range: req.query.range
  };
  console.log(`---> Accessing ${sheetUrl(sheet.id)}\n`);
  return readSheet(await createAuth(), sheet);
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

async function readSheet(auth, sheet) {
  const sheets = google.sheets({version: 'v4', auth});
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: sheet.id,
    range: sheet.range,
  });

  const rows = res.data.values;
  return rows.map(row => row.join(', ')).join('\n');
}

exports.handler = (req, res) => {
  Promise.resolve()
    .then(() => main(req))
    .then(result => {
      res.status(200).send(result);
    })
    .catch(e => {
      console.error(e.stack);
      res.status(500).send('Internal server error');
    });
};
