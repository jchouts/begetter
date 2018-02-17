from rest_framework import serializers

from .models import Membership


# Create your models here.


class MembershipSerializer(serializers.ModelSerializer):
    class Meta:
        model = Membership

