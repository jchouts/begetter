from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^training/$', rest_api.TrainingList.as_view()),
    url(r'^training/(?P<pk>[0-9a-z-]+)/$', rest_api.TrainingDetail.as_view()),
]