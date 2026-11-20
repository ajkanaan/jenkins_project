"""Unit tests executable with unittest and pytest."""

import runpy
import unittest
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path

from app import greet


class TestApp(unittest.TestCase):
    def test_greet_world(self):
        self.assertEqual(
            greet("World"), "Hello, World from Anthony John Kanaan!"
        )

    def test_greet_person(self):
        self.assertEqual(
            greet("Jenkins"), "Hello, Jenkins from Anthony John Kanaan!"
        )

    def test_command_line(self):
        output = StringIO()
        with redirect_stdout(output):
            runpy.run_path(
                str(Path(__file__).resolve().parents[1] / "app.py"),
                run_name="__main__",
            )
        self.assertEqual(
            output.getvalue(), "Hello, World from Anthony John Kanaan!\n"
        )


if __name__ == "__main__":
    unittest.main()
