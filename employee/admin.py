# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from .models import Employee
from .models import Position
from .models import EmploymentHistory
from .models import GroupDefault

# Register your models here.
@admin.register(Position)
class PositionAdmin(admin.ModelAdmin):
    list_display = ('position_name', 'job_description', 'active', 'created_ts', 'updated_ts')


@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('user', 'position', 'hire_date', 'start_date', 'term_date', 'manager', 'salary')


@admin.register(GroupDefault)
class GroupDefaultAdmin(admin.ModelAdmin):
    list_display = ('position', 'group')


@admin.register(EmploymentHistory)
class EmploymentHistoryAdmin(admin.ModelAdmin):
    list_display = ('user', 'old_position', 'old_manager', 'old_salary', 'new_position', 'new_manager', 'new_salary')
