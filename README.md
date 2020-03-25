
# Dialogflow Sandbox

For now, it's just Google Sheets API sandbox.

## Usage

1. Enable Sheets API and create a service account that is going to access Google Sheet.
   1. Enable Sheets API on GCP console.
   1. Create an service account and give a permission to use the Sheets API.
   1. Download the JSON key of the service account.
1. Allow the service account to access the Sheet
   1. Open the sheet, select "Share" button on the top-right corner.
   1. Put service account `client_email` address and give "Viewer" permission.
   1. Memo the sheet id, and the range on the sheet.
1. Run:

    ```sh
    export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
    node index.js <sheet id> <range on sheet>
    ```

For example, there is a public sheet used in Google Sheets' doc, with this sheet, you can:

```sh
node index.js '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms' 'Class Data!A2:E'
```

## References

* [Node.js Quickstart - Google Sheets API v4](https://developers.google.com/sheets/api/quickstart/nodejs)
* [Google APIs Node.js Client, API Reference Documentation](https://googleapis.dev/nodejs/googleapis/latest/index.html)
* [How to access Google Spreadsheets with a service account credentials? - StackOverflow](https://stackoverflow.com/questions/27067825/how-to-access-google-spreadsheets-with-a-service-account-credentials)
* [Connecting to Google Sheets](https://www.dundas.com/support/learning/documentation/connect-to-data/how-to/connecting-to-google-sheets)
