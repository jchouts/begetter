# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from .models import MakerspaceOrganizationSetting
from .models import Makerspace
from .models import MakerspaceSetting
from .models import Address
from .models import Facility
from .models import Graphic
from .models import Document


@admin.register(MakerspaceOrganizationSetting)
class MakerspaceOrganizationSettingAdmin(admin.ModelAdmin):
    list_display = ('setting_name', 'setting_value', 'updated_ts', 'created_ts')

@admin.register(Makerspace)
class MakerspaceAdmin(admin.ModelAdmin):
    list_display = ('location_name', 'location_slug', 'id')

@admin.register(MakerspaceSetting)
class MakerspaceSettingAdmin(admin.ModelAdmin):
    list_display = ('makerspace', 'setting_name', 'setting_value', 'updated_ts', 'created_ts')

@admin.register(Address)
class AddressAdmin(admin.ModelAdmin):
    pass

@admin.register(Facility)
class FacilityAdmin(admin.ModelAdmin):
    pass

@admin.register(Graphic)
class GraphicAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'image', 'makerspace')


@admin.register(Document)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'file', 'makerspace', 'upload_ts')