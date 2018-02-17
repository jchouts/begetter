from rest_framework import serializers

from .models import Training


# Create your models here.


class TrainingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Training

