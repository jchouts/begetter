from rest_framework import serializers

from .models import Space


# Create your models here.


class SpaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Space

