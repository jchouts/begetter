from django.conf.urls import url

from . import rest_api

urlpatterns = [
    url(r'^settings/(?P<setting_name>\w+)/$', rest_api.SettingsDetail.as_view()),
    url(r'^makerspace_org_setting/$', rest_api.MakerspaceOrganizationSettingList.as_view()),
    url(r'^makerspace_org_setting/(?P<pk>[0-9a-z-]+)/$', rest_api.MakerspaceOrganizationSettingDetail.as_view()),
    url(r'^makerspace/$', rest_api.MakerspaceList.as_view()),
    url(r'^makerspace/current$', rest_api.current_makerspace),
    url(r'^makerspace/(?P<pk>[0-9a-z-]+)/$', rest_api.MakerspaceDetail.as_view()),
    url(r'^makerspace_setting/$', rest_api.MakerspaceSettingList.as_view()),
    url(r'^makerspace_setting/(?P<pk>[0-9a-z-]+)/$', rest_api.MakerspaceSettingDetail.as_view()),
    url(r'^address/$', rest_api.AddressList.as_view()),
    url(r'^address/(?P<pk>[0-9a-z-]+)/$', rest_api.AddressDetail.as_view()),
    url(r'^facility/$', rest_api.FacilityList.as_view()),
    url(r'^facility/(?P<pk>[0-9a-z-]+)/$', rest_api.FacilityDetail.as_view()),
    url(r'^graphic/$', rest_api.GraphicList.as_view()),
    url(r'^graphic/(?P<pk>[0-9a-z-]+)/$', rest_api.GraphicDetail.as_view()),
    url(r'^document/$', rest_api.DocumentList.as_view()),
    url(r'^document/(?P<pk>[0-9a-z-]+)/$', rest_api.DocumentDetail.as_view()),
    url(r'^latest_document/(?P<location_slug>\w+)/(?P<name>\w+)/$', rest_api.LatestDocumentByName.as_view()),
    url(r'^group/$', rest_api.GroupList.as_view()),
    url(r'^group/(?P<pk>[0-9a-z-]+)/$', rest_api.GroupDetail.as_view()),
]