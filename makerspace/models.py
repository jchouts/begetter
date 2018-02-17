# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.utils.translation import ugettext_lazy as _
from django.utils.text import slugify


class UserManager(BaseUserManager):
    """Define a model manager for User model with no username field."""

    use_in_migrations = True

    def _create_user(self, email, password, **extra_fields):
        """Create and save a User with the given email and password."""
        if not email:
            raise ValueError('The given email must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        """Create and save a regular User with the given email and password."""
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password, **extra_fields):
        """Create and save a SuperUser with the given email and password."""
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self._create_user(email, password, **extra_fields)


class User(AbstractUser):
    """User model."""

    username = None
    email = models.EmailField(_('email address'), unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()


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


class Graphic(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    makerspace = models.ForeignKey(Makerspace, related_name='graphics')
    name = models.CharField(max_length=30, choices=(('logo_white_bg', 'Logo - White Background'),('logo_black_bg','Logo - Black Background'), ('favicon', 'Favicon')))
    image = models.ImageField(upload_to='graphics') #This will store the file the graphic directory under settings.MEDIA_ROOT

    def __repr__(self):
        return '{} - {}'.format(self.name, self.image.url)

    def __str__(self):
        return self.__repr__()