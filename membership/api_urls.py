from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^membership/$', rest_api.MembershipList.as_view()),
    url(r'^membership/(?P<pk>[0-9a-z-]+)/$', rest_api.MembershipDetail.as_view()),
]