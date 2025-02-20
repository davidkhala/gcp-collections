import os
import unittest
from datetime import datetime

from google.cloud.language import LanguageServiceClient, Document
from google.oauth2 import service_account

from davidkhala.gcp.auth import OptionsInterface
from davidkhala.gcp.auth.service_account import from_service_account
from davidkhala.gcp.auth.api_key import from_api_key


class SyntaxTestCase(unittest.TestCase):

    def test_from_any(self):
        from davidkhala.gcp.auth.ci import credential
        credential()

    def test_from_service_account(self):
        o = from_service_account(
            client_email=os.environ.get('CLIENT_EMAIL'),
            private_key=os.environ.get('PRIVATE_KEY'),
        )
        credentials = o.credentials
        self.assertIsInstance(credentials, service_account.Credentials)
        self.assertFalse(credentials.valid)
        self.assertIsNone(o.expiry)
        OptionsInterface.token.fget(o)
        self.assertIsNotNone(o.expiry)
        self.assertIsInstance(o.expiry, datetime)

    def test_from_api_key(self):
        api_key = os.environ.get('API_KEY')
        client = LanguageServiceClient(
            client_options=from_api_key(api_key),
        )
        text = "Hello, world!"

        # Make a request to analyze the sentiment of the text.
        sentiment = client.analyze_sentiment(
            document=Document({
                "content": text,
                "type_": Document.Type.PLAIN_TEXT
            }),
        ).document_sentiment

        self.assertEqual(sentiment.score, sentiment.magnitude)


if __name__ == '__main__':
    unittest.main()
