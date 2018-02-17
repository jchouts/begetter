from .models import Space

from .serializers import SpaceSerializer


from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view


class SpaceList(generics.ListCreateAPIView):
    queryset = Space.objects.all()
    serializer_class = SpaceSerializer


class SpaceDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Space.objects.all()
    serializer_class = SpaceSerializer
