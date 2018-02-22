'use strict'

Application.Services.factory 'DjangoAuth', ['$cookies', '$http', ($cookies, $http) ->
  register: (data) ->
    $http.post('/api/webaccount/webaccounts/', data)
  login: (data) ->
    loginSuccessFn = (data, status, headers, config) ->
      $cookies.authenticatedAccount = JSON.stringify(data.data)
      window.location = '/'
    loginErrorFn = (data, status, headers, config) ->
      console.error('Epic failure!')

    config_obj =
      withCredentials: true
      headers:
        'Authorization': 'Basic ' + btoa(data.email + ':' + data.password)
    $http.post(url='/api/webaccount/auth/',data=null, config=config_obj).then(loginSuccessFn, loginErrorFn)
  getAuthenticatedAccount: () ->
    if !$cookies.authenticatedAccount
      return
    JSON.parse($cookies.authenticatedAccount)
  isAuthenticated: () ->
    !!$cookies.authenticatedAccount
  setAuthenticatedAccount: (account) ->
    $cookies.authenticatedAccount = JSON.stringify(account)
  unauthenticate: () ->
    delete $cookies.authenticatedAccount
]

#["$resource", ($resource)->
#  $resource "/api/webaccount/webaccounts\\/",
#    login:
#      method: 'POST'
#      transformRequest: (data, headersGetter) ->
#        headers = headersGetter()
#        headers['Authorization'] = ('Basic ' + btoa(data.username + ':' + data.password))
#    upcoming:
#      method: 'DELETE'
#    register:
#      url: '/api/webaccount/signup'
#      method: 'POST'
#]
