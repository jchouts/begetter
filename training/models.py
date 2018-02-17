# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models
from machine.models import Machine,MachineCategory
from membership.models import MembershipTier
import uuid
from django.conf import settings
from makerspace.models import User

# Create your models here.
class Training(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField()
    slug = models.SlugField(max_length=50)
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)
    characteristic = models.TextField()
    disabled = models.BooleanField(default=False)


class TrainingAvailability(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    training = models.ForeignKey(Training)
    availability = models.CharField(max_length=30)
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)


class TrainingMachines(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    training = models.ForeignKey(Training)
    machine_category = models.ForeignKey(MachineCategory, null=True, blank=True)
    machine = models.ForeignKey(Machine, null=True, blank=True)

class TrainingPricing(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    training = models.ForeignKey(Training)
    membership_tier = models.ForeignKey(MembershipTier)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('training', 'membership_tier')

class UserTraining(models.Model):
    user = models.ForeignKey(User)
    training = models.ForeignKey(Training)
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)

