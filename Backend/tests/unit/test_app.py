from flask import Flask
from kiwi.app import create_app


def test_create_app():
    app = create_app()
    assert isinstance(app, Flask)
