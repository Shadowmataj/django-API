"""
Sample test
"""

from django.test import SimpleTestCase

from app import calc


class CalcTest(SimpleTestCase):
    """Test calc module"""

    def test_add_numbers(self):
        """Test adding numbers together."""

        res = calc.add(5, 6)

        self.assertEqual(res, 11)

    def test_substract_numbers(self):
        """Test substracting numbers together"""

        res = calc.substract(20, 10)

        self.assertEqual(res, 10)
