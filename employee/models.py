# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from makerspace.models import User
from django.db import models
from django.contrib.auth.models import Group
import uuid

# Create your models here.


class Position(models.Model):
    position_name = models.CharField(max_length=100)
    job_description = models.TextField()
    active = models.BooleanField(default=True)
    created_ts = models.DateTimeField(auto_now=True)
    updated_ts = models.DateTimeField(auto_now_add=True)

# Eric Hess - President
# Jim Schrempp - Vice President
# James Pistorino - Treasurer
# Robert Smith - Secretary
# Regina Sakols - Operations
# Kirsten Winkelbauer - Social Media & Marketing


class Employee(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(User)
    hire_date = models.DateTimeField()
    start_date = models.DateTimeField()
    term_date = models.DateTimeField(default=None, blank=True, null=True)
    manager = models.ForeignKey(User, related_name='employees')
    salary = models.DecimalField(max_digits=12, decimal_places=2)
    position = models.ForeignKey(Position, related_name='employees')


class GroupDefault(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    position = models.ForeignKey(Position, related_name='default_groups')
    group = models.ForeignKey(Group, related_name='position_defaults')


class EmploymentHistory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, related_name='employment_hist')
    old_manager = models.ForeignKey(User, related_name='old_managers')
    old_salary = models.DecimalField(max_digits=12, decimal_places=2)
    old_position = models.ForeignKey(Position, related_name='new_postitions')
    new_manager = models.ForeignKey(User, related_name='new_managers')
    new_salary = models.DecimalField(max_digits=12, decimal_places=2)
    new_position = models.ForeignKey(Position, related_name='new_positions')


# Can an employee hold multiple positions?
# Can an employee have multiple managers? - Who does the General Manager report to?
# Who do the board members report to?

class PerformanceReviews(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    employee = models.ForeignKey(Employee, related_name='reviews_recieved')
    reviewer = models.ForeignKey(Employee, related_name='reviews_given')
    rating = models.IntegerField()
    comments = models.TextField()
    status = models.CharField(max_length=30, choices=(('Draft', 'Draft'), ('Submitted', 'Submitted'), ('Acknowledged', 'Acknowledged')))
    created_ts = models.DateTimeField(auto_now_add=True)
    updates_ts = models.DateTimeField(auto_now=True)