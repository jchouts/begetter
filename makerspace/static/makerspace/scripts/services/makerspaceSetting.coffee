'use strict'

Application.Services.factory 'MakerspaceSetting', ["$resource", ($resource)->
  $resource "/api/makerspace/makerspace_setting/:id/",
    {id: "@id"},
    update:
      method: 'PUT'
    merge:
      method: 'PUT'
      url: '/api/makerspace/makerspace_setting/:id/'
    list:
      url: '/api/makerspace/makerspace_setting/'
      method: 'GET'
      isArray: true
    search:
      method: 'GET'
      url: '/api/makerspace/makerspace_setting/:query'
      params: {search: "@query"}
      isArray: true
]
