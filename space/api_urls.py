from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^space/$', rest_api.SpaceList.as_view()),
    url(r'^space/(?P<pk>[0-9a-z-]+)/$', rest_api.SpaceDetail.as_view()),
]