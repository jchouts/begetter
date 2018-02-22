'use strict'

Application.Services.factory 'Document', ["$resource", ($resource)->
  $resource "/api/makerspace/document/:id",
    {id: "@id"},
    list:
      url: '/api/makerspace/document/'
      method: 'GET'
      isArray: true
    latest:
      url: 'api/makerspace/latest_document/:location_slug/:document_name/'
      params: {location_slug: "@location_slug", document_name: "@document_slug"}
      method: 'GET'
      isArray: false
]
