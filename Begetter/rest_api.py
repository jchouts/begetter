from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.conf import settings
import json
import os


@api_view(['GET'])
def version(request):
    if request.method == 'GET':
        version_file_path = os.path.join(settings.BASE_DIR, '.{}-version'.format(settings.PROJECT_NAME))
        print('Checking file {} for the version number.'.format(version_file_path))
        with open(version_file_path) as version_file:
            version = version_file.readline()
        return Response({'version': version})