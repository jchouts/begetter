from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^machine/$', rest_api.MachineList.as_view()),
    url(r'^machine/(?P<pk>[0-9a-z-]+)/$', rest_api.MachineDetail.as_view()),
]