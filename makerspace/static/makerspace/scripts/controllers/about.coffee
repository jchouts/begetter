'use strict'

Application.Controllers.controller "AboutController", ['$scope', 'Setting', 'Document', ($scope, Setting, Document)->

  ### PUBLIC SCOPE ###

  Setting.get { name: 'about_title'}, (data)->
    $scope.aboutTitle = data

  Setting.get { name: 'about_body'}, (data)->
    $scope.aboutBody = data

  Setting.get { name: 'about_contacts'}, (data)->
    $scope.aboutContacts = data

  # retrieve the CGU
  Document.latest {name: 'cgu-file'}, (cgu) ->
    $scope.cgu = cgu

  # retrieve the CGV
  Document.latest {name: 'cgv-file'}, (cgv) ->
    $scope.cgv = cgv
]
