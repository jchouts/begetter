# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render, redirect
from .models import Makerspace
from .models import Graphic


# Create your views here.
def index(request):
    makerspc = Makerspace.objects.get(location_slug='sf_bay')
    favicon = Graphic.objects.get(name='favicon')
    makerspc.settings.all()
    template_context = {'makerspace': makerspc,
                        'favicon': favicon}
    return render(request, 'makerspace/index.html', template_context)


