# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render, redirect
from .models import Makerspace


# Create your views here.
def index(request):
    makerspc = Makerspace.objects.get(location_slug='sf_bay')
    makerspc.settings.all()
    template_context = {'makerspace': makerspc}
    return render(request, 'makerspace/index.html', template_context)


