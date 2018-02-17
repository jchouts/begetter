# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import uuid
from django.db import models

# Create your models here.
class Space(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField()
    slug = models.SlugField(max_length=50)
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)
    characteristic = models.TextField()
    disabled = models.BooleanField(default=False)