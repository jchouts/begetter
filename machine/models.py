# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.conf import settings

from django.db import models

# Create your models here.

class MachineCategory(models.Model):
    category_name = models.CharField(max_length=255)
    category_slug = models.SlugField()


class Machine(models.Model):
    machine_name = models.CharField(max_length=255)
    machine_category = models.ForeignKey(MachineCategory)
    machine_slug = models.SlugField()
    description = models.TextField()
    specifications = models.TextField()
    created_ts = models.DateTimeField(auto_now_add=True)
    updated_ts = models.DateTimeField(auto_now=True)
    status = models.CharField(max_length=100)
    training_required = models.BooleanField(default=True)
    signoff_available = models.BooleanField(default=False)


class MachineIssueReport(models.Model):
    """
    Users should be able to inform staff of issues with certain machines.
    """
    machine = models.ForeignKey(Machine)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='machine_issue_report_creator')
    issue_description = models.TextField()
    report_date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=30, choices=[('Report Submitted','submitted'),('Report Awknowledged', 'awknowledged'),('Maintenance Scheduled','maint_scheduled'),('Resolved','resolved')])
    updated_by = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='machine_issue_report_updated')
    update_ts = models.DateTimeField(auto_now=True)


class MachineMaintenance(models.Model):
    machine = models.ForeignKey(Machine)
    issue_description = models.TextField()
    issue_reported = models.ForeignKey(MachineIssueReport)
    technician = models.CharField(max_length=100)
    service_description = models.TextField()


class MachineUsage(models.Model):
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