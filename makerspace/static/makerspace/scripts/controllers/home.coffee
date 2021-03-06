'use strict'

Application.Controllers.controller "HomeController", ['$scope', '$stateParams', ($scope, $stateParams)->

  ### PUBLIC SCOPE ###

  ## The last registered members who confirmed their addresses
  #JCH#$scope.lastMembers = lastMembersPromise

  ## The last tweets from the Fablab official twitter account
  #JCH#$scope.lastTweets = []

  ## The last projects published/documented on the plateform
  #JCH#$scope.lastProjects = lastProjectsPromise

  ## The closest upcoming events
  #JCH#$scope.upcomingEvents = upcomingEventsPromise

  ## The admin blogpost
  #JCH#$scope.homeBlogpost = homeBlogpostPromise.setting.value

  ## Twitter username
  #JCH#$scope.twitterName = twitterNamePromise.setting.value

  ##
  # Test if the provided event run on a single day or not
  # @param event {Object} single event from the $scope.upcomingEvents array
  # @returns {boolean} false if the event runs on more that 1 day
  ##
  $scope.isOneDayEvent = (event) ->
    moment(event.start_date).isSame(event.end_date, 'day')



  ### PRIVATE SCOPE ###

  ##
  # Kind of constructor: these actions will be realized first when the controller is loaded
  ##
  initialize = ->
    # we retrieve tweets from here instead of ui-router's promise because, if adblock stop the API request,
    # this prevent the whole home page to be blocked
    #JCH#$scope.lastTweets =  Twitter.query(limit: 1)

    # if we recieve a token to reset the password as GET parameter, trigger the
    # changePassword modal from the parent controller
    if $stateParams.reset_password_token
      $scope.$parent.editPassword($stateParams.reset_password_token)



  ## !!! MUST BE CALLED AT THE END of the controller
  initialize()
]
