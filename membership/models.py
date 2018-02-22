# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.conf import settings
from django.db import models
from datetime import datetime as dt
from django.core.validators import RegexValidator

class MemberProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='member_profile')
    confirmation_sent = models.BinaryField()
    account_confirmed = models.BinaryField()
    address_street1 = models.CharField(max_length=200)
    address_street2 = models.CharField(max_length=200)
    address_country = models.CharField(max_length=200)
    address_city = models.CharField(max_length=200)
    address_state = models.CharField(max_length=50)
    address_zip = models.CharField(max_length=20)
    phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed.")
    phone_number = models.CharField(validators=[phone_regex], max_length=17)
    contact_authorization = models.BooleanField(default=False) # Whether we are allowed to send text messages.
    sms_authorization = models.BooleanField(default=False)


class MembershipTier(models.Model):
    tier_name = models.CharField(max_length=200)
    tier_slug = models.CharField(max_length=10)


class Membership(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL)
    membership_tier = models.ForeignKey(MembershipTier)
    activation_date = models.DateTimeField()
    expiration_date = models.DateTimeField()
    membership_override = models.CharField(max_length=30)  # Need the ability to lock/suspend membership

    @property
    def activation_status(self):
        current_date = dt.now()
        if current_date > self.activation_date and current_date < self.expiration_date:
            return True
        else:
            return False


class EmergencyContact(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='emergency_contacts')
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed.")
    phone_number = models.CharField(validators=[phone_regex], max_length=17)


class Questionaire(models.Model):
    questionaire_name = models.CharField(max_length=100)
    questionaire_slug = models.CharField(max_length=100)


class QuestionaireVersion(models.Model):
    questionaire = models.ForeignKey(Questionaire)
    version_number = models.IntegerField()
    comment = models.CharField(max_length=500)


class Question(models.Model):
    questionaire_version = models.ForeignKey(QuestionaireVersion)
    question = models.CharField(max_length=500)

#Woodshop, MetalShop, Computer Lab, Textiles, Welding/Fabrication, Autoshop, Electronics, Plastics

class Spaces(models.Model):
    space_name = models.CharField(max_length=255)
    space_slug = models.SlugField()
    space_description = models.TextField()
    space_features = models.TextField()

class StorageType(models.Model):
    type_name= models.CharField(max_length=255)
    type_slug = models.SlugField()
    width = models.IntegerField()
    depth = models.IntegerField()
    height = models.IntegerField()
    storage_description = models.TextField()

class StorageSpace(models.Model):
    pass




# Enter Building, Exit Building
class MemberTimesheet(models.Model):
    """
    Events can be triggered by RFID tags or by automated events.
        If a user forgets to badge out, an automated event should badge them out when the shop closes.
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL)
    event_name = models.CharField(max_length=255)
    event_slug = models.SlugField()
    event_description = models.TextField()
    facility = models.CharField(max_length=200)
    action = models.CharField(max_length=30, choices=[('enter', 'enter'), ('exit', 'exit')])
    impetus = models.CharField(max_length=30, choices=[('rfid', 'rfid'), ('automated', 'automated')])

# class Pledge(models.Model):
#     pass
#
# class Donation(models.Model):
#     pass