'use strict'

Application.Controllers.controller "ApplicationController", ["$rootScope", "$scope", "$window", '$locale', "Session",  "$uibModal", "$state", '$interval', "Setting", "Makerspace", 'Version'
, ($rootScope, $scope, $window, $locale, Session, $uibModal, $state, $interval, Setting, Makerspace, Version) ->



  ### PRIVATE STATIC CONSTANTS ###

  # User's notifications will get refreshed every 30s
  NOTIFICATIONS_CHECK_PERIOD = 30000



  ### PUBLIC SCOPE ###

  $scope.testvar = 'This will be shown as a test of angular controller.'

  ## Fab-manager's version
  $scope.version =
      version: ''

  ## currency symbol for the current locale (cf. angular-i18n)
  $rootScope.currencySymbol = $locale.NUMBER_FORMATS.CURRENCY_SYM;

  ##
  #  Set the current Makerspace - from nginit django values
  ##
  $scope.setCurrentMakerspace = (makerspace_id) ->
    $rootScope.currentMakerspace = Makerspace.get( id : makerspace_id )

  ##
  # Set the current user to the provided value and initialize the session
  # @param user {Object} Rails/Devise user
  ##
  $scope.setCurrentUser = (user) ->
    unless angular.isUndefinedOrNull(user)
      $rootScope.currentUser = user
      Session.create(user);
      getNotifications()
      # fab-manager's app-version
      if user.role == 'admin'
        $scope.version = Version.get()
      else
        $scope.version = {version: ''}


  ##
  # Login callback
  # @param e {Object} see https://docs.angularjs.org/guide/expression#-event-
  # @param callback {function}
  ##
  $scope.login = (e, callback) ->
    e.preventDefault() if e
    openLoginModal null, null, callback



  ##
  # Logout callback
  # @param e {Object} see https://docs.angularjs.org/guide/expression#-event-
  ##
  $scope.logout = (e) ->
    e.preventDefault()
    console.log(" you're signed out now.");



  ##
  # Open the modal window allowing the user to create an account.
  # @param e {Object} see https://docs.angularjs.org/guide/expression#-event-
  ##
  $scope.signup = (e) ->
    e.preventDefault() if e

    $uibModal.open
      templateUrl: 'shared/signupModal.html'
      size: 'md'
      controller: ['$scope', '$uibModalInstance', 'Group', 'CustomAsset', ($scope, $uibModalInstance, Group, CustomAsset) ->
        # default parameters for the date picker in the account creation modal
        $scope.datePicker =
          format: Fablab.uibDateFormat
          opened: false
          options:
            startingDay: Fablab.weekStartingDay

        # callback to open the date picker (account creation modal)
        $scope.openDatePicker = ($event) ->
          $event.preventDefault()
          $event.stopPropagation()
          $scope.datePicker.opened = true

        # retrieve the groups (standard, student ...)
        Group.query (groups) ->
          $scope.groups = groups

        # retrieve the CGU
        CustomAsset.get {name: 'cgu-file'}, (cgu) ->
          $scope.cgu = cgu.custom_asset

        # default user's parameters
        $scope.user =
          is_allow_contact: true
          is_allow_newsletter: false

        # Errors display
        $scope.alerts = []
        $scope.closeAlert = (index) ->
          $scope.alerts.splice(index, 1)

        # callback for form validation
        $scope.ok = ->
          # try to create the account
          $scope.alerts = []
          # remove 'organization' attribute
          orga = $scope.user.organization
          delete $scope.user.organization
          # register on server

      ]
    .result['finally'](null).then (user) ->
      # when the account was created succesfully, set the session to the newly created account
      $scope.setCurrentUser(user)


  ##
  # Open the modal window allowing the user to change his password.
  # @param token {string} security token for password changing. The user should have recieved it by mail
  ##
  $scope.editPassword = (token) ->
    $uibModal.open
      templateUrl: 'shared/passwordEditModal.html'
      size: 'md'
      controller: ['$scope', '$uibModalInstance', '$http', '_t', ($scope, $uibModalInstance, $http, _t) ->
        $scope.user =
          reset_password_token: token
        $scope.alerts = []
        $scope.closeAlert = (index) ->
          $scope.alerts.splice(index, 1)

        $scope.changePassword = ->
          $scope.alerts = []
          $http.put('/users/password.json', {user: $scope.user}).success (data) ->
            $uibModalInstance.close()
          .error (data) ->
            angular.forEach data.errors, (v, k) ->
              angular.forEach v, (err) ->
                $scope.alerts.push
                  msg: k+': '+err
                  type: 'danger'
      ]
    .result['finally'](null).then (user) ->
      growl.success(_t('your_password_was_successfully_changed'))


  ##
  # Compact/Expend the width of the left navigation bar
  # @param e {Object} see https://docs.angularjs.org/guide/expression#-event-
  ##
  $scope.toggleNavSize = (event) ->
    if typeof event == 'undefined'
      console.error '[ApplicationController::toggleNavSize] Missing event parameter'
      return

    toggler = $(event.target)
    toggler = toggler.closest('[data-toggle^="class"]') unless toggler.data('toggle')

    $class = toggler.data()['toggle']
    $target = toggler.data('target') or toggler.attr('data-link')

    if $class
      $tmp = $class.split(':')[1]
      $classes = $tmp.split(',') if $tmp

    if $target
      $targets = $target.split(',')

    if $classes and $classes.length
      $.each $targets, ( index, value ) ->
        if $classes[index].indexOf( '*' ) != -1
          patt = new RegExp( '\\s'
              +  $classes[index].replace( /\*/g, '[A-Za-z0-9-_]+' ).split( ' ' ).join( '\\s|\\s' )
              + '\\s', 'g' )
          $(toggler).each ( i, it ) ->
            cn = ' ' + it.className + ' '
            while patt.test( cn )
              cn = cn.replace( patt, ' ' )
            it.className = $.trim( cn )

        ($targets[index] !='#') and $($targets[index]).toggleClass($classes[index]) or toggler.toggleClass($classes[index])

    toggler.toggleClass('active')
    return


  ### PRIVATE SCOPE ###
  ##
  # Kind of constructor: these actions will be realized first when the controller is loaded
  ##
  initialize = ->

    # try to retrieve any currently logged user


    # bind to the $stateChangeStart event (AngularJS/UI-Router)
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      return unless toState.data



    # we stop polling notifications when the page is not in foreground
    onPageVisible (state) ->
      $rootScope.toCheckNotifications = (state is 'visible')



    Makerspace.current (data)->
      $scope.fablabName = 'test'
    $scope.nameGenre = 'male'


    # shorthands

    $rootScope.login = $scope.login



  ##
  # Retreive once the notifications from the server and display a message popup for each new one.
  # Then, periodically check for new notifications.
  ##
  getNotifications = ->
    $rootScope.toCheckNotifications = true
    unless $rootScope.checkNotificationsIsInit or !$rootScope.currentUser
      setTimeout ->
        # we request the most recent notifications
        Notification.last_unread (notifications) ->
          $rootScope.lastCheck = new Date()
          $scope.notifications = notifications.totals

          toDisplay = []
          angular.forEach notifications.notifications, (n) ->
            toDisplay.push(n)

          if toDisplay.length < notifications.totals.unread
            toDisplay.push({message: {description: _t('and_NUMBER_other_notifications', {NUMBER: notifications.totals.unread - toDisplay.length}, "messageformat")}})

          angular.forEach toDisplay, (notification) ->
            growl.info(notification.message.description)
      , 2000

      checkNotifications = ->
        if $rootScope.toCheckNotifications
          Notification.polling({last_poll: $rootScope.lastCheck}).$promise.then (data) ->
            $rootScope.lastCheck = new Date()
            $scope.notifications = data.totals

            angular.forEach data.notifications, (notification) ->
              growl.info(notification.message.description)

      $interval(checkNotifications, NOTIFICATIONS_CHECK_PERIOD)
      $rootScope.checkNotificationsIsInit = true







  ##
  # Detect if the current page (tab/window) is active of put as background.
  # When the status changes, the callback is triggered with the new status as parameter
  # Inspired by http://stackoverflow.com/questions/1060008/is-there-a-way-to-detect-if-a-browser-window-is-not-currently-active#answer-1060034
  ##
  onPageVisible = (callback) ->
    hidden = 'hidden'

    onchange = (evt) ->
      v = 'visible'
      h = 'hidden'
      evtMap =
        focus: v
        focusin: v
        pageshow: v
        blur: h
        focusout: h
        pagehide: h
      evt = evt or window.event
      if evt.type of evtMap
        if typeof callback == 'function' then callback(evtMap[evt.type])
      else
        if typeof callback == 'function' then callback(if @[hidden] then 'hidden' else 'visible')
      return

    # Standards:
    if hidden of document
      document.addEventListener 'visibilitychange', onchange
    else if (hidden = 'mozHidden') of document
      document.addEventListener 'mozvisibilitychange', onchange
    else if (hidden = 'webkitHidden') of document
      document.addEventListener 'webkitvisibilitychange', onchange
    else if (hidden = 'msHidden') of document
      document.addEventListener 'msvisibilitychange', onchange
    # IE 9 and lower
    else if 'onfocusin' of document
      document.onfocusin = document.onfocusout = onchange
    # All others
    else
      window.onpageshow = window.onpagehide = window.onfocus = window.onblur = onchange
    # set the initial state (but only if browser supports the Page Visibility API)
    if document[hidden] != undefined
      onchange type: if document[hidden] then 'blur' else 'focus'



  ## !!! MUST BE CALLED AT THE END of the controller
  initialize()
]
