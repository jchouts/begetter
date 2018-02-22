'use strict'

Application.Services.factory 'Group', ["$resource", ($resource)->
  $resource "/api/makerspace/group/:id",
    {id: "@id"},
    update:
      method: 'PUT'
]
