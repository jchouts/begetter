
from django.conf.urls import url, include
from django.contrib import admin
import rest_api

urlpatterns = [
    url(r'^webaccount/', include('webaccount.api_urls')),
    url(r'^makerspace/', include('makerspace.api_urls')),
    url(r'^machine/', include('machine.api_urls')),
    url(r'^event/', include('event.api_urls')),
    url(r'^space/', include('space.api_urls')),
    url(r'^membership/', include('membership.api_urls')),
    url(r'^training/', include('training.api_urls')),
    url(r'^version/$', rest_api.version)
]
