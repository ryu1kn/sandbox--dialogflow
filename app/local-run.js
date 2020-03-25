const {handler} = require('./index');

const req = {
  query: {
    sheetId: process.argv[2],
    range: process.argv[3]
  }
}

const res = {
  status: function (code) {
    console.log(`status = ${code}`)
    return this
  },
  send: function (data) {
    console.log(`response = ${data}`)
    return this
  }
}

handler(req, res)
