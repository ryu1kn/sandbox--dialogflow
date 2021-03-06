
# Google Sheets read demo

For now, it's just Google Sheets API sandbox.

## Usage

1. Enable Sheets API and create a service account that is going to access Google Sheet.
   1. Enable Sheets API on GCP console.
   1. Download the JSON key of the service account.
1. Allow the service account to access the Sheet
   1. Open the sheet, select "Share" button on the top-right corner.
   1. Put service account `client_email` address and give "Viewer" permission.
   1. Memo the sheet id, and the range on the sheet.
1. Run:

    ```sh
    export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
    node local-run <sheet id> <range on sheet>
    ```

    You can use your user's temporary credentials to run the script locally.

    ```sh
    gcloud auth application-default login
    export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json
    ```

For example, there is a public sheet used in Google Sheets' doc, with this sheet,
you can do the following to print the contents on the sheet:

```sh
$ node local-run '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms' 'Class Data!A2:E'
---> Accessing https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/view

Alexandra, Female, 4. Senior, CA, English
Andrew, Male, 1. Freshman, SD, Math
...
```

## Note

Unlike AWS Lambda, you don't need to package up `npm_modules` directory
when uploading your Cloud Function code to a storage bucket.

But, make sure you bundle a lock file.

## References

* [Node.js Quickstart - Google Sheets API v4](https://developers.google.com/sheets/api/quickstart/nodejs)
* [Google APIs Node.js Client, API Reference Documentation](https://googleapis.dev/nodejs/googleapis/latest/index.html)
* [How to access Google Spreadsheets with a service account credentials? - StackOverflow](https://stackoverflow.com/questions/27067825/how-to-access-google-spreadsheets-with-a-service-account-credentials)
* [Connecting to Google Sheets](https://www.dundas.com/support/learning/documentation/connect-to-data/how-to/connecting-to-google-sheets)
* [Using Environment Variables - Cloud Functions > Documentation](https://cloud.google.com/functions/docs/env-var)
* [dialogflow / DialogflowConversation /](https://actions-on-google.github.io/actions-on-google-nodejs/classes/dialogflow.dialogflowconversation.html#intent)
