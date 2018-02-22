from .models import User
from rest_framework import serializers
from django.contrib.auth import update_session_auth_hash


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)
    confirm_password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ('id', 'password', 'confirm_password', 'pseudonym', 'first_name', 'last_name', 'email', 'contact_allowed', 'is_allow_newsletter')
        write_only_fields = ('password','confirm_password')
        read_only_fields = ('is_staff', 'is_superuser', 'is_active', 'date_joined',)

    def update(self, instance, validated_data):
        instance.pseudonym = validated_data.get('pseudonym', instance.pseudonym)

        instance.save()

        password = validated_data.get('password', None)
        confirm_password = validated_data.get('confirm_password', None)

        if password and confirm_password and password == confirm_password:
            instance.set_password(password)
            instance.save()

        update_session_auth_hash(self.context.get('request'), instance)

        return instance