from rest_framework import serializers

from .models import MakerspaceOrganizationSetting
from .models import Makerspace
from .models import MakerspaceSetting
from .models import Address
from .models import Facility
from .models import Graphic

# Create your models here.


class MakerspaceOrganizationSettingSerializer(serializers.ModelSerializer):
    class Meta:
        model = MakerspaceOrganizationSetting
        fields = ('id', 'setting_name', 'setting_value', 'created_ts', 'updated_ts')


class MakerspaceSettingSerializer(serializers.ModelSerializer):
    class Meta:
        model = MakerspaceSetting
        fields = ('id', 'makerspace', 'setting_name', 'setting_value', 'created_ts', 'updated_ts')


class MakerspaceSerializer(serializers.ModelSerializer):
    settings = MakerspaceSettingSerializer(many=True, read_only=True)

    class Meta:
        model = Makerspace
        fields = ('id', 'location_name', 'location_slug', 'settings')


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = ('id', 'address1', 'address2', 'city', 'state', 'zip_code', 'country')


class FacilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Facility
        fields = ('id', 'makerspace', 'facility_name', 'address')


class GraphicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Graphic
        fields = ('id', 'makerspace', 'name', 'image')


