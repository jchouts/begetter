# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render

# Create your views here.
from . import authentication, serializers  # see previous post[1] for user serializer.
from .models import User
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import redirect, render
from rest_framework.views import APIView
from rest_framework import viewsets, status
from rest_framework.response import Response
from .authentication import QuietBasicAuthentication
from .serializers import UserSerializer
from rest_framework.permissions import AllowAny

from .permissions import IsStaffOrTargetUser
import json

class UserView(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    model = User

    def get_permissions(self):
        # allow non-authenticated user to create via POST
        return (AllowAny() if self.request.method == 'POST'
                else IsStaffOrTargetUser()),

    def create(self, request):
        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            if 'confirm_password' in serializer.validated_data:
                del serializer.validated_data['confirm_password']
            User.objects.create_user(**serializer.validated_data)

            return Response(serializer.validated_data, status=status.HTTP_201_CREATED)

        return Response({
            'status': 'Bad request',
            'message': 'Account could not be created with received data.'
        }, status=status.HTTP_400_BAD_REQUEST)


def login_view(request):
    if request.method == 'GET':
        if not request.user.is_authenticated():
            return render(request, 'budget/login.html')
        else:
            context = {'myvar': 'value'}
            return render(request, 'budget/index.html', context)
    if request.method == 'POST':
        login_email = request.POST['loginEmail']
        login_password = request.POST['loginPassword']
        user = authenticate(username=login_email, password=login_password)
        if user is not None:
            if user.is_active:
                login(request, user)
                return redirect('/cashflow/')
            else:
                context = {'error': 'Invalid Username/Password'}
                return render(request, 'budget/error.html', context)
        else:
            context = {'error': 'Invalid Username/Password'}
            return render(request, 'budget/error.html', context)

class AuthView(APIView):
    authentication_classes = (QuietBasicAuthentication,)

    def post(self, request, *args, **kwargs):
        login(request, request.user)
        return Response(UserSerializer(request.user).data)

    def delete(self, request, *args, **kwargs):
        logout(request)
        return Response({}, status=status.HTTP_204_NO_CONTENT)


class LoginView(APIView):
    def post(self, request, format=None):
        data = json.loads(request.body)

        email = data.get('email', None)
        password = data.get('password', None)

        account = authenticate(email=email, password=password)

        if account is not None:
            if account.is_active:
                login(request, account)

                serialized = UserSerializer(account)

                return Response(serialized.data)
            else:
                return Response({
                    'status': 'Unauthorized',
                    'message': 'This account has been disabled.'
                }, status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response({
                'status': 'Unauthorized',
                'message': 'Username/password combination invalid.'
            }, status=status.HTTP_401_UNAUTHORIZED)