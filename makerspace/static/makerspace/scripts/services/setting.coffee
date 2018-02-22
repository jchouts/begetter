'use strict'

Application.Services.factory 'Setting', ["$resource", ($resource)->
  $resource "/api/makerspace/settings/:name",
    {name: "@name"},
    update:
      method: 'PUT'
    query:
      isArray: false
]
