from requests import get, post

from .credentials import CLIENT_ID, CLIENT_SECRET
from .models import Token
from django.utils import timezone
from datetime import timedelta

BASE_URL = "https://api.spotify.com/v1/me/"

# Check Tokens
def check_tokens(session_id):
    tokens = Token.objects.filter(user = session_id)
    if tokens: 
        return tokens[0]
    else:
        return None
    

def create_or_update_tokens(session_id, access_token, refresh_token, expires_in, token_type):
    tokens = check_tokens(session_id)
    expires_in = timezone.now() + timedelta(seconds = expires_in)

    # Update tokens if they exist
    if tokens:
        tokens.access_token = access_token
        tokens.refresh_token = refresh_token
        tokens.expires_in = expires_in
        tokens. token_type = token_type
        tokens. save(update_fields=['access_token', 'refresh_token', 'expires_in', 'token_type'])

    else:
        tokens = Token(
            user = session_id,
            access_token = access_token,
            refresh_token = refresh_token,
            expires_in = expires_in,
            token_type = token_type
        )
        tokens.save()

def is_spotify_authenticated(session_id):
    tokens = check_tokens(session_id=session_id)
    if tokens:
        if tokens.expires_in <= timezone.now():
            pass
        return True
    return False

def refresh_token_func(session_id):
    refresh_token = check_tokens(session_id=session_id).refresh_token
    response = post('https://accounts.spotify.com/api/token', data={
        'grant_type' : "refresh_token",
        'refresh_token' : refresh_token,
        'client id' : CLIENT_ID,
        'client_secret' : CLIENT_SECRET,
    }).json()

    access_token = response.get('access_token')
    expires_in = response.get('expires_in')
    token_type = response.get('token_type')

    create_or_update_tokens(
        session_id= session_id,
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=expires_in,
        token_type=token_type
    )

def spotify_requests_execution(session_id,endpoint):
    token = check_tokens(session_id=session_id)
    print("Session ID",session_id)
    headers = {'Content-Type' : 'application/json','Authorization' : 'Bearer ' + token.access_token }
    response = get(BASE_URL + endpoint,{},headers = headers)
    print(BASE_URL + endpoint)
    if response:
        print(response)

    else:
        print("No Response!")


    if response.status_code == 200:
        try:
            return response.json()
        except ValueError as e:
            print(f"Error decoding JSON: {str(e)}")
            return {'error': 'Invalid JSON response from Spotify API'}
    else:
        print(f"Request failed: {response.status_code} - {response.text}")
        return {'error': f'Request failed: {response.status_code} - {response.reason}'}