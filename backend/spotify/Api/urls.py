from .views import *
from django.urls import path
urlpatterns = [
    path("auth-url",AuthenticationURL.as_view()),
    path("redirect",spotify_redirect),
    path("check-auth",CheckAuthentication.as_view()),
    path("current-song",CurrentSong.as_view()),
    path('top-tracks-long', TopTracksLong.as_view()),
    path('top-tracks-medium', TopTracksMedium.as_view()),
    path('top-tracks-short', TopTracksShort.as_view()),
]