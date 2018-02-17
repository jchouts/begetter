# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
from django.utils.translation import ugettext_lazy as _

from .models import MakerspaceOrganizationSetting
from .models import Makerspace
from .models import MakerspaceSetting
from .models import Address
from .models import Facility
from .models import Graphic

from .models import User

@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    """Define admin model for custom User model with no email field."""

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (_('Personal info'), {'fields': ('first_name', 'last_name')}),
        (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser',
                                       'groups', 'user_permissions')}),
        (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2'),
        }),
    )
    list_display = ('email', 'first_name', 'last_name', 'is_staff')
    search_fields = ('email', 'first_name', 'last_name')
    ordering = ('email',)



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
    pass
