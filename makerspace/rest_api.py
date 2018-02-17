from .models import MakerspaceOrganizationSetting
from .models import Makerspace
from .models import MakerspaceSetting
from .models import Address
from .models import Facility
from .models import Graphic

from .serializers import MakerspaceOrganizationSettingSerializer
from .serializers import MakerspaceSerializer
from .serializers import MakerspaceSettingSerializer
from .serializers import AddressSerializer
from .serializers import FacilitySerializer
from .serializers import GraphicSerializer

from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view

from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

@api_view(['GET'])
def current_makerspace(request):
    makerspace = Makerspace.objects.get(location_name='San Francisco Peninsula')
    makerspace.settings.all()
    serializer = MakerspaceSerializer(makerspace, many=False)
    return Response(serializer.data)


class MakerspaceOrganizationSettingList(generics.ListCreateAPIView):
    queryset = MakerspaceOrganizationSetting.objects.all()
    serializer_class = MakerspaceOrganizationSettingSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter,)
    filter_fields = ('setting_name', 'setting_value')
    search_fields = ('setting_name',)


class MakerspaceOrganizationSettingDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = MakerspaceOrganizationSetting.objects.all()
    serializer_class = MakerspaceOrganizationSettingSerializer


class MakerspaceList(generics.ListCreateAPIView):
    queryset = Makerspace.objects.all()
    serializer_class = MakerspaceSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter, OrderingFilter,)
    filter_fields = ('location_name',)
    search_fields = ('location_name',)


class MakerspaceDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Makerspace.objects.all()
    serializer_class = MakerspaceSerializer


class MakerspaceSettingList(generics.ListCreateAPIView):
    queryset = MakerspaceSetting.objects.all()
    serializer_class = MakerspaceSettingSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter,)
    filter_fields = ('makerspace', 'makerspace__location_name', 'setting_name', 'setting_value')
    search_fields = ('makerspace', 'makerspace__location_name',  'setting_name')


class MakerspaceSettingDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = MakerspaceSetting.objects.all()
    serializer_class = MakerspaceSettingSerializer


class AddressList(generics.ListCreateAPIView):
    queryset = Address.objects.all()
    serializer_class = AddressSerializer


class AddressDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Address.objects.all()
    serializer_class = AddressSerializer


class FacilityList(generics.ListCreateAPIView):
    queryset = Facility.objects.all()
    serializer_class = FacilitySerializer


class FacilityDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Facility.objects.all()
    serializer_class = FacilitySerializer


class GraphicList(generics.ListCreateAPIView):
    queryset = Graphic.objects.all()
    serializer_class = GraphicSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter,)
    filter_fields = ('makerspace', 'makerspace__location_slug', 'name')
    search_fields = ('makerspace__location_slug', 'name')


class GraphicDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Graphic.objects.all()
    serializer_class = GraphicSerializer
