from django import template
from django.core.exceptions import ObjectDoesNotExist

register = template.Library()

@register.filter(name='find_setting_by_name')
def find_setting_by_name(settings_queryset, setting_name):
    try:
        return settings_queryset.get(setting_name=setting_name).setting_value
    except ObjectDoesNotExist:
        return ''