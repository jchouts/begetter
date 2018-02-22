# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import uuid
from django.db import models
from django.utils.text import slugify


class MakerspaceOrganizationSetting(models.Model):
    """
    Used for Common settings across all makerspace locations.
    Examples: org_name, slogan
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    setting_name = models.CharField(max_length=255, unique=True)
    setting_value = models.TextField()
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return '{}:{}'.format(self.setting_name, self.setting_value)


class Makerspace(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    location_name = models.CharField(max_length=100, unique=True)
    location_slug = models.SlugField(max_length=50, unique=True)

    def __repr__(self):
        return '{}'.format(self.location_name)

    def __str__(self):
        return self.__repr__()


class MakerspaceSetting(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    makerspace = models.ForeignKey(Makerspace, related_name='settings')
    setting_name = models.CharField(max_length=255)
    setting_value = models.TextField()
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('makerspace', 'setting_name')

    def __repr__(self):
        return '{}:{}:{}'.format(self.makerspace.location_name, self.setting_name, self.setting_value)


class Address(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    address1 = models.CharField(max_length=255)
    address2 = models.CharField(max_length=300)
    city = models.CharField(max_length=255)
    state = models.CharField(max_length=255)
    zip_code = models.IntegerField()
    country = models.CharField(max_length=255)


class Facility(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    makerspace = models.ForeignKey(Makerspace)
    facility_name = models.CharField(max_length=100)
    address = models.OneToOneField(Address)


class Document(models.Model):
    """Table to store documents. For example: User Agreements, Privacy Policies.
        Documents should never be updated/deleted. They should only added and all queries should get the
        latest document with a given name for the makerspace.
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    makerspace = models.ForeignKey(Makerspace, related_name='documents')
    name = models.CharField(max_length=100)
    file = models.FileField()
    upload_ts = models.DateTimeField(auto_now_add=True)


class Graphic(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    makerspace = models.ForeignKey(Makerspace, related_name='graphics')
    name = models.CharField(max_length=30, choices=(('logo_white_bg', 'Logo - White Background'),('logo_black_bg','Logo - Black Background'), ('favicon', 'Favicon')))
    image = models.ImageField(upload_to='graphics') #This will store the file the graphic directory under settings.MEDIA_ROOT

    def __repr__(self):
        return '{} - {}'.format(self.name, self.image.url)

    def __str__(self):
        return self.__repr__()