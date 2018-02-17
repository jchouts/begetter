# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.conf import settings
from space.models import Space

from django.db import models
import uuid

# Create your models here.
class Event(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    event_slug = models.SlugField(max_length=50)
    event_summary = models.CharField(max_length=200)
    event_description = models.TextField()
    creator = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='events_created')
    create_ts = models.DateTimeField(auto_now_add=True)
    update_ts = models.DateTimeField(auto_now=True)
    attendee_limit = models.IntegerField()
    slots_available = models.IntegerField()
    event_type = models.CharField(max_length=30, choices=(('Public', 'public'), ('Members Only', 'members_only'), ('Private', 'private')))
    # private events will not show up on the website. Maybe we allow the admins to invite others. Maybe we just let the admins tell others through word of mouth.
    event_admins = models.ManyToManyField(settings.AUTH_USER_MODEL, 'events_admin') # Only event admins can edit event details. and will get notificaitons about approval statuses
    all_day = models.BooleanField(default=False)
    start_ts = models.DateTimeField()
    end_ts = models.DateTimeField()
    space = models.ForeignKey(Space)


class MemberEvent(Event):
    event_status = models.CharField(max_length=30, choices=(('Draft', 'Draft'), ('Pending Approval', 'pending_approval'), ('Approved','approved'), ('Denied', 'Denied'), ('Requires Updates','Requires Updates')))


class EventApproval(models.Model):
    member_event = models.ForeignKey(MemberEvent)
    approver = models.ForeignKey(settings.AUTH_USER_MODEL)
    approval_ts = models.DateTimeField(auto_now=True)
    decision = models.CharField(max_length=30, choices=(('Approve', 'Approve'),('Deny','deny'),('Request Changes','Request Changes')))
    comment = models.TextField()
