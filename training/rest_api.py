from .models import Training

from .serializers import TrainingSerializer


from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view


class TrainingList(generics.ListCreateAPIView):
    queryset = Training.objects.all()
    serializer_class = TrainingSerializer


class TrainingDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Training.objects.all()
    serializer_class = TrainingSerializer
