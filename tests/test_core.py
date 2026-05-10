"""Tests for ml_deploy.core."""

import unittest

from ml_deploy.ml_deploy import say_hello, add_numbers  # noqa: F401


class TestCore(unittest.TestCase):
    def test_say_hello(self):
        self.assertEqual(say_hello(), "Hello from ml_deploy!")

    def test_add_numbers(self):
        self.assertEqual(add_numbers(2, 3), 5)
        self.assertEqual(add_numbers(-1, 1), 0)
        self.assertEqual(add_numbers(0, 0), 0)


if __name__ == "__main__":
    unittest.main()