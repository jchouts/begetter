from .models import Machine

from .serializers import MachineSerializer


from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view


class MachineList(generics.ListCreateAPIView):
    queryset = Machine.objects.all()
    serializer_class = MachineSerializer


class MachineDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Machine.objects.all()
    serializer_class = MachineSerializer
