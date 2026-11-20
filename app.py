"""Personalized greeting application for EECE 435L Lab 10."""


def greet(name):
    """Return a greeting attributed to the project author."""
    return f"Hello, {name} from Anthony John Kanaan!"


if __name__ == "__main__":
    print(greet("World"))
