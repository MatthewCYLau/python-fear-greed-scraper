import unittest
import pytest
from src.scraper.scraper import Scraper

class TestScraper(unittest.TestCase):

    @pytest.fixture(autouse=True)
    def _pass_fixtures(self, capsys):
        self.capsys = capsys

    def test_scraper_model(self):
        scraper = Scraper()
        scraper.start_scraper()
        captured = self.capsys.readouterr()
        self.assertEqual('', captured.out)