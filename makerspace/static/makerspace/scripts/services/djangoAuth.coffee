'use strict'

Application.Services.factory 'DjangoAuth', ['$cookies', '$http', '$q', ($cookies, $http, $q) ->
  get_authenticated_account = () ->
    if $cookies.authenticatedAccount
      return JSON.parse($cookies.authenticatedAccount)

  is_authenticated = () ->
    !!$cookies.authenticatedAccount

  unauthenticate = () ->
    delete $cookies.authenticatedAccount

  set_authenticated_account = (account) ->
    $cookies.authenticatedAccount = JSON.stringify(account)

  register: (data) ->
    $http.post('/api/webaccount/webaccounts/', data)
  login: (data) ->
    if angular.isUndefinedOrNull(data)
      promise = $q (resolve, reject) ->
        if is_authenticated()
          account = get_authenticated_account()
          resolve(account)
        else
          reject('Unable to find an Authenticated Account')
        return
      promise
    else
      loginSuccessFn = (data, status, headers, config) ->
        set_authenticated_account(data.data)
        window.location = '/'
        data.data
      loginErrorFn = (data, status, headers, config) ->
        console.error('Epic failure!')
        deffered = $q.defer()
        deffered.reject('Login Failed with status ' + status)
        deferred.promise

      config_obj =
        withCredentials: true
        headers:
          'Authorization': 'Basic ' + btoa(data.email + ':' + data.password)

      return $http.post(url='/api/webaccount/auth/',data=null, config=config_obj).then(loginSuccessFn, loginErrorFn)
  logout: () ->
    $http.delete('/api/webaccount/auth/').then((data, status, headers, config) ->
      unauthenticate()
    , (data, status, headers, config) ->
      console.error('Epic failure!')
    )
  getAuthenticatedAccount: get_authenticated_account
  isAuthenticated: is_authenticated
  setAuthenticatedAccount: set_authenticated_account
  unauthenticate: unauthenticate
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
