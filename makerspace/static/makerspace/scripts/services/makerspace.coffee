'use strict'

Application.Services.factory 'Makerspace', ["$resource", ($resource)->
  $resource "/api/makerspace/makerspace/:id/",
    {id: "@id"},
    update:
      method: 'PUT'
    merge:
      method: 'PUT'
      url: '/api/makerspace/makerspace/:id/'
    list:
      url: '/api/makerspace/makerspace/'
      method: 'GET'
      isArray: true
    search:
      method: 'GET'
      url: '/api/makerspace/makerspace/:query'
      params: {search: "@query"}
      isArray: true
    current:
      method: 'GET'
      url: 'api/makerspace/makerspace/current/'
]
