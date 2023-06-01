import unittest
import pytest
from src.scraper.scraper import Scraper

class TestScraper(unittest.TestCase):

    @pytest.fixture(autouse=True)
    def _pass_fixtures(self, capsys):
        self.capsys = capsys

    def test_scraper_should_send_email(self):
        self.assertEqual(Scraper.should_send_email(20), True)
        self.assertEqual(Scraper.should_send_email(40), False)