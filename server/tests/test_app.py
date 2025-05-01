import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    response = client.get('/healthz')
    assert response.status_code == 200
    assert b'200 OK' in response.data

def test_404_handler(client):
    response = client.get('/nonexistent')
    assert response.status_code == 404
    assert b'Not Found' in response.data