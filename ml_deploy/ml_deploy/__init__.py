def say_hello() -> str:
    return "Hello from ml_deploy!"


def add_numbers(a: int, b: int) -> int:
    return a + b


__all__ = ["say_hello", "add_numbers"]
