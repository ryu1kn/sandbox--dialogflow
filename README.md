
# Dialogflow Sandbox

## Usage

1. Enable Sheets API on GCP console.
1. Create an service account and give a permission to use the Sheets API.
1. Download the JSON key of the service account.
1. Run:

    ```sh
    export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
    node index.js
    ```

## References

* [Node.js Quickstart - Google Sheets API v4](https://developers.google.com/sheets/api/quickstart/nodejs)
* [Google APIs Node.js Client, API Reference Documentation](https://googleapis.dev/nodejs/googleapis/latest/index.html)
* [How to access Google Spreadsheets with a service account credentials? - StackOverflow](https://stackoverflow.com/questions/27067825/how-to-access-google-spreadsheets-with-a-service-account-credentials)
