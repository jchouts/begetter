from django.conf.urls import url

from . import views, rest_api

urlpatterns = [
    url(r'^$|^#.*$', views.index, name='index'),
]