from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework import status,response
from requests import Request,post
from django.http import HttpResponseRedirect
from .credentials import CLIENT_ID, CLIENT_SECRET, REDIRECT_URI 
from .extras import *
# Create your views here.
class AuthenticationURL(APIView):
    def get(self,request,format=None):
        scopes = "user-read-currently-playing user-read-playback-state user-modify-playback-state"
        url = Request("GET","https://accounts.spotify.com/authorize",params={
            'scope' : scopes,
            'response' : response,
            'response_type' : 'code',
            'redirect_uri' : REDIRECT_URI,
            'client_id' : CLIENT_ID,

        }).prepare().url
        return HttpResponseRedirect(url)
    
def spotify_redirect(request,format = None):
    code = request.GET.get('code')
    error = request.GET.get('error')

    if error:
        return error
    
    response = post('https//accounts.spotify.com/api/token', data = {
        'grant_type' : 'authorization_code',
        'code' : code,
        'redirect_uri' : REDIRECT_URI,
        'client_id' : CLIENT_ID,
        'client_secret' : CLIENT_SECRET
    }).json()

    access_token = response.get('access_token')
    refresh_token = response.get('refresh_token')
    expires_in = response.get('expires_in')
    token_type = response.get('token_type')

    authkey = request.session.session_key

    if not request.session.exists(authkey):
        request.session.create()
        authkey = request.session.session_key
    
    create_or_update_tokens(
        session_id= authkey,
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=expires_in,
        token_type=token_type
    )

    redirect_uri = ""

    return HttpResponseRedirect(redirect_uri)