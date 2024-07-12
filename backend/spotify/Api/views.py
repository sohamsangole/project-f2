from django.shortcuts import render
import requests
from rest_framework.views import APIView
from rest_framework import status,response
from requests import Request,post
from rest_framework.response import Response 
from django.http import HttpResponseRedirect
from .credentials import CLIENT_ID, CLIENT_SECRET, REDIRECT_URI 
from .extras import *
# Create your views here.
class AuthenticationURL(APIView):
    def get(self,request,format=None):
        scopes = "user-read-email user-library-read user-library-modify playlist-read-private playlist-modify-public playlist-modify-private user-follow-read user-follow-modify user-top-read user-read-recently-played user-read-currently-playing user-read-playback-state user-modify-playback-state user-read-private user-read-email"
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
    
    response = post('https://accounts.spotify.com/api/token', data = {
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

    redirect_url = f"http://127.0.0.1:8000/spotify/current-song?key={authkey}"
    return HttpResponseRedirect(redirect_url)

class CheckAuthentication(APIView):
    def get(self,request,format=None):
        key = self.request.session.session_key
        if not self.request.session.exists(key):
            self.request.session.create()
            key = self.request.session.session_key

        auth_status = is_spotify_authenticated(key)

        redirect_uri = f"http://127.0.0.1:8000/spotify/top-tracks?key={key}" if auth_status else f"http://127.0.0.1:8000/spotify/auth-url"
        return HttpResponseRedirect(redirect_uri)
        
class CurrentSong(APIView):
    kwarg = "key"
    def get(self,request,format=None):
        key = request.GET.get(self.kwarg)
        token = Token.objects.filter(user = key)

        endpoint = "player/currently-playing"
        response = spotify_requests_execution(key,endpoint)

        if 'error' in response or 'item' not in response:
            return Response({},status=status.HTTP_204_NO_CONTENT)
        
        item = response.get('item')
        progress = response.get('progress_ms')
        is_playing = response.get('is_playing')

        duration = item.get('duration_ms')
        song_id = item.get('id')
        title = item.get("name")
        album_cover = item.get("album").get("images")[0].get("url")

        artists = ""
        for i, artist in enumerate(item.get("artists")):
            if i > 0:
                artists += ", "
                name = artist.get("name")
                artists += name

        song = {
            "id" : song_id,
            "title" : title,
            "artist" : artists,
            "duration" : duration,
            "time" : progress,
            "album_cover" : album_cover,
            "is_playing": is_playing
        }
        print(song)
        return Response(song,status=status.HTTP_200_OK)
    

class TopTracksLong(APIView):
    kwarg = "key"
    def get(self, request, format=None):
        key = request.GET.get(self.kwarg)
        if not key:
            return Response({'error': 'Key parameter missing'}, status=status.HTTP_400_BAD_REQUEST)
        print(key)
        token = Token.objects.filter(user = key)
        if not token:
            return Response({'error': 'Invalid session key'}, status=status.HTTP_400_BAD_REQUEST)
        print(token)
        endpoint = 'top/tracks?time_range=long_term&limit=5'
        response = spotify_requests_execution(key, endpoint)
        if 'error' in response or response is None:    
            return Response(response, status=status.HTTP_400_BAD_REQUEST)
        top_tracks = response.get('items', [])
            
        tracks_data = []
        for track in top_tracks:
            track_info = {
                    "id": track.get("id"),
                    "name": track.get("name"),
                    "artists": ", ".join([artist.get("name") for artist in track.get("artists")]),
                    "album": track.get("album").get("name"),
                    "album_cover": track.get("album").get("images")[0].get("url") if track.get("album").get("images") else None
            }
            tracks_data.append(track_info)
            
        return Response(tracks_data, status=status.HTTP_200_OK)
    

class TopTracksMedium(APIView):
    kwarg = "key"
    def get(self, request, format=None):
        key = request.GET.get(self.kwarg)
        if not key:
            return Response({'error': 'Key parameter missing'}, status=status.HTTP_400_BAD_REQUEST)
        print(key)
        token = Token.objects.filter(user = key)
        if not token:
            return Response({'error': 'Invalid session key'}, status=status.HTTP_400_BAD_REQUEST)
        print(token)
        endpoint = 'top/tracks?time_range=medium_term&limit=5'
        response = spotify_requests_execution(key, endpoint)
        if 'error' in response or response is None:    
            return Response(response, status=status.HTTP_400_BAD_REQUEST)
        top_tracks = response.get('items', [])
            
        tracks_data = []
        for track in top_tracks:
            track_info = {
                    "id": track.get("id"),
                    "name": track.get("name"),
                    "artists": ", ".join([artist.get("name") for artist in track.get("artists")]),
                    "album": track.get("album").get("name"),
                    "album_cover": track.get("album").get("images")[0].get("url") if track.get("album").get("images") else None
            }
            tracks_data.append(track_info)
            
        return Response(tracks_data, status=status.HTTP_200_OK)
    
class TopTracksShort(APIView):
    kwarg = "key"
    def get(self, request, format=None):
        key = request.GET.get(self.kwarg)
        if not key:
            return Response({'error': 'Key parameter missing'}, status=status.HTTP_400_BAD_REQUEST)
        print(key)
        token = Token.objects.filter(user = key)
        if not token:
            return Response({'error': 'Invalid session key'}, status=status.HTTP_400_BAD_REQUEST)
        print(token)
        endpoint = 'top/tracks?time_range=short_term&limit=5'
        response = spotify_requests_execution(key, endpoint)
        if 'error' in response or response is None:    
            return Response(response, status=status.HTTP_400_BAD_REQUEST)
        top_tracks = response.get('items', [])
            
        tracks_data = []
        for track in top_tracks:
            track_info = {
                    "id": track.get("id"),
                    "name": track.get("name"),
                    "artists": ", ".join([artist.get("name") for artist in track.get("artists")]),
                    "album": track.get("album").get("name"),
                    "album_cover": track.get("album").get("images")[0].get("url") if track.get("album").get("images") else None
            }
            tracks_data.append(track_info)
            
        return Response(tracks_data, status=status.HTTP_200_OK)