from rest_framework import serializers

from .models import Event


# Create your models here.


class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event

