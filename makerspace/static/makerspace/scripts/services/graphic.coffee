'use strict'

Application.Services.factory 'Graphic', ["$resource", ($resource)->
  $resource "/api/makerspace/graphic/:id",
    {id: "@id"},
    list:
      url: '/api/makerspace/graphic/'
      method: 'GET'
      isArray: true
]
