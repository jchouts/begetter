'use strict';

/**
* The application file bootstraps the angular app by  initializing the main module and
* creating namespaces and moduled for controllers, filters, services, and directives.
*/

var Application = Application || {};

Application.Constants = angular.module('makerspaceAngularApp.constants', []);
Application.Services = angular.module('makerspaceAngularApp.services', []);
Application.Controllers = angular.module('makerspaceAngularApp.controllers', []);
Application.Filters = angular.module('makerspaceAngularApp.filters', []);
Application.Directives = angular.module('makerspaceAngularApp.directives', []);


angular.module('makerspaceAngularApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngCookies', 'ui.router', 'ui.bootstrap', 'ui.select', 'xeditable', 'makerspaceAngularApp.filters', 'makerspaceAngularApp.services', 'makerspaceAngularApp.controllers', 'makerspaceAngularApp.router']).
config(['$interpolateProvider','$httpProvider',
    function($interpolateProvider, $httpProvider) {
        $interpolateProvider.startSymbol('{a');
        $interpolateProvider.endSymbol('a}');
        $httpProvider.defaults.xsrfCookieName = 'csrftoken';
        $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken';


    }]).run(["$rootScope", "$log", "$state", "editableOptions",
      function($rootScope, $log, $state, editableOptions) {

      // Angular-xeditable (click-to-edit elements, used in admin backoffice)
      editableOptions.theme = 'bs3';

      // Alter the UI-Router's $state, registering into some information concerning the previous $state.
      // This is used to allow the user to navigate to the previous state
      $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams){
        $state.prevState = fromState;
        $state.prevParams = fromParams;
      });

      // Global config: if true, the whole 'Plans & Subscriptions' feature will be disabled in the application
      $rootScope.fablabWithoutPlans = Fablab.withoutPlans;
      // Global config: it true, the whole 'Spaces' features will be disabled in the application
      $rootScope.fablabWithoutSpaces = Fablab.withoutSpaces;
      $rootScope.org_slug = Fablab.org_slug;
      $rootScope.location_slug = Fablab.location_slug;
      $rootScope.makerspace_id = Fablab.makerspace_id;

      // Global function to allow the user to navigate to the previous screen (ie. $state).
      // If no previous $state were recorded, navigate to the home page
      $rootScope.backPrevLocation = function(event){
        event.preventDefault();
        event.stopPropagation();
        if($state.prevState.name == ""){
          $state.prevState = "app.public.home";
        }
        $state.go($state.prevState, $state.prevParams);
      };



      // Prevent the usage of the application for members with incomplete profiles: they will be redirected to
      // the 'profile completion' page. This is especially useful for user's accounts imported through SSO.
      $rootScope.$on('$stateChangeStart', function (event, toState) {
        Auth.currentUser().then(function(currentUser) {
          if (currentUser.need_completion && toState.name != 'app.logged.profileCompletion') {
            $state.go('app.logged.profileCompletion');
          }
        });
      });


      /**
       * This helper method builds and return an array contaning every integers between
       * the provided start and end.
       * @param start {number}
       * @param end {number}
       * @return {Array} [start .. end]
       */
      $rootScope.intArray = function(start, end) {
        var arr = [];
        for (var i = start; i < end; i++) { arr.push(i); }
        return arr;
      };

  }]).constant('angularMomentConfig', {
    timezone: Fablab.timezone
  });

angular.isUndefinedOrNull = function(val) {
  return angular.isUndefined(val) || val === null
};