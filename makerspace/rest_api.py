from django.contrib.auth.models import Group
from .models import MakerspaceOrganizationSetting
from .models import Makerspace
from .models import MakerspaceSetting
from .models import Address
from .models import Facility
from .models import Graphic
from .models import Document

from .serializers import MakerspaceOrganizationSettingSerializer
from .serializers import MakerspaceSerializer
from .serializers import MakerspaceSettingSerializer
from .serializers import AddressSerializer
from .serializers import FacilitySerializer
from .serializers import GraphicSerializer
from .serializers import DocumentSerializer
from .serializers import GroupSerializer

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

class SettingsDetail(generics.RetrieveAPIView):
    lookup_field = 'setting_name'
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


class DocumentList(generics.ListCreateAPIView):
    queryset = Document.objects.all()
    serializer_class = DocumentSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter,)
    filter_fields = ('makerspace', 'makerspace__location_slug', 'name')
    search_fields = ('makerspace__location_slug', 'name')


class DocumentDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Document.objects.all()
    serializer_class = DocumentSerializer


class LatestDocumentByName(generics.RetrieveAPIView):
    queryset = Document.objects.all()
    serializer_class = DocumentSerializer

    def retrieve(self, request, *args, **kwargs):
        location_slug = kwargs.get('location_slug')
        document_name = kwargs.get('name')
        # Note the use of `get_queryset()` instead of `self.queryset`
        queryset = self.get_queryset().filter(makerspace__location_slug=location_slug, name=document_name).latest('upload_ts')
        serializer = DocumentSerializer(queryset, many=False)
        return Response(serializer.data)

class GroupList(generics.ListCreateAPIView):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer


class GroupDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Facility.objects.all()
    serializer_class = GroupSerializer