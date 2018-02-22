from django.conf.urls import url,include
from rest_framework import routers

from . import rest_api
router = routers.DefaultRouter()
router.register(r'webaccounts', rest_api.UserView, 'list')

urlpatterns = [
    url(r'^auth/', rest_api.AuthView.as_view(), name='authenticate'),
]

urlpatterns += router.urls