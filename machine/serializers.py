from rest_framework import serializers

from .models import Machine


# Create your models here.


class MachineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Machine

