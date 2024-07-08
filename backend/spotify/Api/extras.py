from .models import Token
from django.utils import timezone
from datetime import timedelta

BASE_URL = "https://api.spotify.com/v1/me"

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
        tokens. save(update_fields=['access_token', 'refresh_token, expires_in, token_type'])

    else:
        tokens = Token(
            user = session_id,
            access_token = access_token,
            refresh_token = refresh_token,
            expires_in = expires_in,
            token_type = token_type
        )
        tokens.save()