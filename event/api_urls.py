from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^event/$', rest_api.EventList.as_view()),
    url(r'^event/(?P<pk>[0-9a-z-]+)/$', rest_api.EventDetail.as_view()),
]