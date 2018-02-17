angular.module('makerspaceAngularApp.router', ['ui.router']).
  config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $locationProvider.hashPrefix('!')
    $urlRouterProvider.otherwise("/")

    # abstract root parents states
    # these states controls the access rights to the various routes inherited from them
    $stateProvider
      .state 'app',
        abstract: true
        views:
          'header':
            templateUrl: 'static/makerspace/views/header.html'
          'leftnav':
            templateUrl: 'static/makerspace/views/leftnav.html'
            controller: 'MainNavController'
          'main': {}
        resolve:
          logoFile: ['Graphic', (Graphic) ->
                 Graphic.get({name: 'logo-file'}).$promise
          ]
          logoBlackFile: ['Graphic', (Graphic) ->
            Graphic.get({name: 'logo-black-file'}).$promise
          ]

        onEnter: ['$rootScope', 'logoFile', 'logoBlackFile', ($rootScope, logoFile, logoBlackFile) ->
          ## Application logo
          $rootScope.logo = logoFile.custom_asset
          $rootScope.logoBlack = logoBlackFile.custom_asset
        ]
      .state 'app.public',
        abstract: true
      .state 'app.logged',
        abstract: true
        data:
          authorizedRoles: ['member', 'admin']
        resolve:
          currentUser: ['Auth', (Auth)->
            Auth.currentUser()
          ]
        onEnter: ["$state", "$timeout", "currentUser", "$rootScope", ($state, $timeout, currentUser, $rootScope)->
          $rootScope.currentUser = currentUser
        ]
      .state 'app.admin',
        abstract: true
        data:
          authorizedRoles: ['admin']
        resolve:
          currentUser: ['Auth', (Auth)->
            Auth.currentUser()
          ]
        onEnter: ["$state", "$timeout", "currentUser", "$rootScope", ($state, $timeout, currentUser, $rootScope)->
          $rootScope.currentUser = currentUser
        ]



      # main pages
      .state 'app.public.about',
        url: '/about'
        views:
          'content@':
            templateUrl: 'static/makerspace/views/about.html'
            controller: 'AboutController'
      .state 'app.public.home',
        url: '/?reset_password_token'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/home.html'
            controller: 'HomeController'
        resolve:
          faviconImage: ['$stateParams', 'Graphic', ($stateParams, Graphic) ->
                Graphic.list({name: 'Favicon'}).$promise
          ]
          #JCH#lastMembersPromise: ['Member', (Member)->
          #JCH#  Member.lastSubscribed(limit: 4).$promise
          #JCH#]
          #JCH#lastProjectsPromise: ['Project', (Project)->
          #JCH#  Project.lastPublished().$promise
          #JCH#]
          #JCH#upcomingEventsPromise: ['Event', (Event)->
          #JCH#  Event.upcoming(limit: 3).$promise
          #JCH#]
          #JCH#homeBlogpostPromise: ['Setting', (Setting)->
          #JCH#  Setting.get(name: 'home_blogpost').$promise
          #JCH#]
          #JCH#twitterNamePromise: ['Setting', (Setting)->
          #JCH#  Setting.get(name: 'twitter_name').$promise
          #JCH#]
        onEnter: ['$rootScope', 'faviconImage', ($rootScope, faviconImage) ->
          ## Application logo
          $rootScope.faviconImage = faviconImage
        ]

      # profile completion (SSO import passage point)
      .state 'app.logged.profileCompletion',
        url: '/profile_completion'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/profile/complete.html'
            controller: 'CompleteProfileController'
        resolve:
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "['fablab_name', 'name_genre']").$promise
          ]
          activeProviderPromise: ['AuthProvider', (AuthProvider) ->
            AuthProvider.active().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
          cguFile: ['CustomAsset', (CustomAsset) ->
            CustomAsset.get({name: 'cgu-file'}).$promise
          ]
          memberPromise: ['Member', 'currentUser', (Member, currentUser)->
            Member.get(id: currentUser.id).$promise
          ]




      # dashboard
      .state 'app.logged.dashboard',
        abstract: true
        url: '/dashboard'
        resolve:
          memberPromise: ['Member', 'currentUser', (Member, currentUser)->
            Member.get(id: currentUser.id).$promise
          ]
      .state 'app.logged.dashboard.profile',
        url: '/profile'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/profile.html'
            controller: 'DashboardController'
      .state 'app.logged.dashboard.settings',
        url: '/settings'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/settings.html'
            controller: 'EditProfileController'
        resolve:
          groups: ['Group', (Group)->
            Group.query().$promise
          ]
          activeProviderPromise: ['AuthProvider', (AuthProvider) ->
            AuthProvider.active().$promise
          ]
      .state 'app.logged.dashboard.projects',
        url: '/projects'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/projects.html'
            controller: 'DashboardController'
      .state 'app.logged.dashboard.trainings',
        url: '/trainings'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/trainings.html'
            controller: 'DashboardController'
      .state 'app.logged.dashboard.events',
        url: '/events'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/events.html'
            controller: 'DashboardController'
      .state 'app.logged.dashboard.invoices',
        url: '/invoices'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/invoices.html'
            controller: 'DashboardController'
      .state 'app.logged.dashboard.wallet',
        url: '/wallet'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/dashboard/wallet.html'
            controller: 'WalletController'
        resolve:
          walletPromise: ['Wallet', 'currentUser', (Wallet, currentUser)->
            Wallet.getWalletByUser(user_id: currentUser.id).$promise
          ]
          transactionsPromise: ['Wallet', 'walletPromise', (Wallet, walletPromise)->
            Wallet.transactions(id: walletPromise.id).$promise
          ]


      # members
      .state 'app.logged.members_show',
        url: '/members/:id'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/members/show.html'
            controller: 'ShowProfileController'
        resolve:
          memberPromise: ['$stateParams', 'Member', ($stateParams, Member)->
            Member.get(id: $stateParams.id).$promise
          ]
      .state 'app.logged.members',
        url: '/members'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/members/index.html'
            controller: 'MembersController'
        resolve:
          membersPromise: ['Member', (Member)->
            Member.query({requested_attributes:'[profile]', page: 1, size: 10}).$promise
          ]

      # projects
      .state 'app.public.projects_list',
        url: '/projects?q&page&theme_id&component_id&machine_id&from&whole_network'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/projects/index.html.erb'
            controller: 'ProjectsController'
        resolve:
          themesPromise: ['Theme', (Theme)->
             Theme.query().$promise
          ]
          componentsPromise: ['Component', (Component)->
            Component.query().$promise
          ]
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
      .state 'app.logged.projects_new',
        url: '/projects/new'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/projects/new.html'
            controller: 'NewProjectController'
        resolve:
          allowedExtensions: ['Project', (Project)->
            Project.allowedExtensions().$promise
          ]
      .state 'app.public.projects_show',
        url: '/projects/:id'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/projects/show.html'
            controller: 'ShowProjectController'
        resolve:
          projectPromise: ['$stateParams', 'Project', ($stateParams, Project)->
            Project.get(id: $stateParams.id).$promise
          ]
      .state 'app.logged.projects_edit',
        url: '/projects/:id/edit'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/projects/edit.html'
            controller: 'EditProjectController'
        resolve:
          projectPromise: ['$stateParams', 'Project', ($stateParams, Project)->
            Project.get(id: $stateParams.id).$promise
          ]
          allowedExtensions: ['Project', (Project)->
              Project.allowedExtensions().$promise
          ]


      # machines
      .state 'app.public.machines_list',
        url: '/machines'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/machines/index.html.erb'
            controller: 'MachinesController'
        resolve:
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
      .state 'app.admin.machines_new',
        url: '/machines/new'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/machines/new.html'
            controller: 'NewMachineController'
      .state 'app.public.machines_show',
        url: '/machines/:id'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/machines/show.html'
            controller: 'ShowMachineController'
        resolve:
          machinePromise: ['Machine', '$stateParams', (Machine, $stateParams)->
            Machine.get(id: $stateParams.id).$promise
          ]
      .state 'app.logged.machines_reserve',
        url: '/machines/:id/reserve'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/machines/reserve.html'
            controller: 'ReserveMachineController'
        resolve:
          plansPromise: ['Plan', (Plan)->
            Plan.query().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
          machinePromise: ['Machine', '$stateParams', (Machine, $stateParams)->
            Machine.get(id: $stateParams.id).$promise
          ]
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "['machine_explications_alert',
                                   'booking_window_start',
                                   'booking_window_end',
                                   'booking_move_enable',
                                   'booking_move_delay',
                                   'booking_cancel_enable',
                                   'booking_cancel_delay',
                                   'subscription_explications_alert']").$promise
          ]
      .state 'app.admin.machines_edit',
        url: '/machines/:id/edit'
        views:
          'main@':
            templateUrl: 'static/makerspace/views/machines/edit.html'
            controller: 'EditMachineController'
        resolve:
          machinePromise: ['Machine', '$stateParams', (Machine, $stateParams)->
            Machine.get(id: $stateParams.id).$promise
          ]
      # spaces
      .state 'app.public.spaces_list',
        url: '/spaces'
        abstract: Fablab.withoutSpaces
        views:
          'main@':
            templateUrl: 'static/makerspace/views/spaces/index.html'
            controller: 'SpacesController'
        resolve:
          spacesPromise: ['Space', (Space)->
            Space.query().$promise
          ]
      .state 'app.admin.space_new',
        url: '/spaces/new'
        abstract: Fablab.withoutSpaces
        views:
          'main@':
            templateUrl: 'static/makerspace/views/spaces/new.html'
            controller: 'NewSpaceController'
      .state 'app.public.space_show',
        url: '/spaces/:id'
        abstract: Fablab.withoutSpaces
        views:
          'main@':
            templateURL: 'static/makerspace/views/spaces/show.html'
            controller: 'ShowSpaceController'
        resolve:
          spacePromise: ['Space', '$stateParams', (Space, $stateParams)->
            Space.get(id: $stateParams.id).$promise
          ]
      .state 'app.admin.space_edit',
        url: '/spaces/:id/edit'
        abstract: Fablab.withoutSpaces
        views:
          'main@':
            templateURL: 'static/makerspace/views/spaces/edit.html'
            controller: 'EditSpaceController'
        resolve:
          spacePromise: ['Space', '$stateParams', (Space, $stateParams)->
            Space.get(id: $stateParams.id).$promise
          ]
      .state 'app.logged.space_reserve',
        url: '/spaces/:id/reserve'
        abstract: Fablab.withoutSpaces
        views:
          'main@':
            templateURL: 'static/makerspace/views/spaces/reserve.html'
            controller: 'ReserveSpaceController'
        resolve:
          spacePromise: ['Space', '$stateParams', (Space, $stateParams)->
            Space.get(id: $stateParams.id).$promise
          ]
          availabilitySpacesPromise: ['Availability', '$stateParams', (Availability, $stateParams)->
            Availability.spaces({spaceId: $stateParams.id}).$promise
          ]
          plansPromise: ['Plan', (Plan)->
            Plan.query().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "['booking_window_start',
                                   'booking_window_end',
                                   'booking_move_enable',
                                   'booking_move_delay',
                                   'booking_cancel_enable',
                                   'booking_cancel_delay',
                                   'subscription_explications_alert',
                                   'space_explications_alert']").$promise
          ]
      # trainings
      .state 'app.public.trainings_list',
        url: '/trainings'
        views:
          'main@':
            templateURL: 'static/makerspace/views/trainings/index.html'
            controller: 'TrainingsController'
        resolve:
          trainingsPromise: ['Training', (Training)->
            Training.query({ public_page: true }).$promise
          ]
      .state 'app.public.training_show',
        url: '/trainings/:id'
        views:
          'main@':
            templateURL: 'static/makerspace/views/trainings/show.html'
            controller: 'ShowTrainingController'
        resolve:
          trainingPromise: ['Training', '$stateParams', (Training, $stateParams)->
            Training.get({id: $stateParams.id}).$promise
          ]
      .state 'app.logged.trainings_reserve',
        url: '/trainings/:id/reserve'
        views:
          'main@':
            templateURL: 'static/makerspace/views/trainings/reserve.html'
            controller: 'ReserveTrainingController'
        resolve:
          explicationAlertPromise: ['Setting', (Setting)->
            Setting.get(name: 'training_explications_alert').$promise
          ]
          plansPromise: ['Plan', (Plan)->
            Plan.query().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
          availabilityTrainingsPromise: ['Availability', '$stateParams', (Availability, $stateParams)->
            Availability.trainings({trainingId: $stateParams.id}).$promise
          ]
          trainingPromise: ['Training', '$stateParams', (Training, $stateParams)->
              Training.get({id: $stateParams.id}).$promise unless $stateParams.id == 'all'
          ]
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "['booking_window_start',
                                   'booking_window_end',
                                   'booking_move_enable',
                                   'booking_move_delay',
                                   'booking_cancel_enable',
                                   'booking_cancel_delay',
                                   'subscription_explications_alert',
                                   'training_explications_alert',
                                   'training_information_message']").$promise
          ]
      # notifications
      .state 'app.logged.notifications',
        url: '/notifications'
        views:
          'main@':
            templateURL: 'static/makerspace/views/notifications/index.html'
            controller: 'NotificationsController'
      # pricing
      .state 'app.public.plans',
        url: '/plans'
        abstract: Fablab.withoutPlans
        views:
          'main@':
            templateURL: 'static/makerspace/views/plans/index.html'
            controller: 'PlansIndexController'
        resolve:
          subscriptionExplicationsPromise: ['Setting', (Setting)->
            Setting.get(name: 'subscription_explications_alert').$promise
          ]
          plansPromise: ['Plan', (Plan)->
            Plan.query().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
      # events
      .state 'app.public.events_list',
        url: '/events'
        views:
          'main@':
            templateURL: 'static/makerspace/views/events/index.html'
            controller: 'EventsController'
        resolve:
          categoriesPromise: ['Category', (Category) ->
            Category.query().$promise
          ]
          themesPromise: ['EventTheme', (EventTheme) ->
            EventTheme.query().$promise
          ]
          ageRangesPromise: ['AgeRange', (AgeRange) ->
            AgeRange.query().$promise
          ]
      .state 'app.public.events_show',
        url: '/events/:id'
        views:
          'main@':
            templateURL: 'static/makerspace/views/events/show.html'
            controller: 'ShowEventController'
        resolve:
          eventPromise: ['Event', '$stateParams', (Event, $stateParams)->
            Event.get(id: $stateParams.id).$promise
          ]
          priceCategoriesPromise: ['PriceCategory', (PriceCategory) ->
            PriceCategory.query().$promise
          ]
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "['booking_move_enable', 'booking_move_delay', 'event_explications_alert']").$promise
          ]
      # global calendar (trainings, machines and events)
      .state 'app.public.calendar',
        url: '/calendar'
        views:
          'main@':
            templateURL: 'static/makerspace/views/calendar/calendar.html'
            controller: 'CalendarController'
        resolve:
          bookingWindowStart: ['Setting', (Setting)->
            Setting.get(name: 'booking_window_start').$promise
          ]
          bookingWindowEnd: ['Setting', (Setting)->
            Setting.get(name: 'booking_window_end').$promise
          ]
          trainingsPromise: ['Training', (Training)->
            Training.query().$promise
          ]
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
          spacesPromise: ['Space', (Space) ->
            Space.query().$promise
          ]

      # --- namespace /admin/... ---
      # calendar
      .state 'app.admin.calendar',
        url: '/admin/calendar'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/calendar/calendar.html'
            controller: 'AdminCalendarController'
        resolve:
          bookingWindowStart: ['Setting', (Setting)->
            Setting.get(name: 'booking_window_start').$promise
          ]
          bookingWindowEnd: ['Setting', (Setting)->
            Setting.get(name: 'booking_window_end').$promise
          ]
          machinesPromise: ['Machine', (Machine) ->
            Machine.query().$promise
          ]
      # project's elements
      .state 'app.admin.project_elements',
        url: '/admin/project_elements'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/project_elements/index.html'
            controller: 'ProjectElementsController'
        resolve:
          componentsPromise: ['Component', (Component)->
            Component.query().$promise
          ]
          licencesPromise: ['Licence', (Licence)->
            Licence.query().$promise
          ]
          themesPromise: ['Theme', (Theme)->
            Theme.query().$promise
          ]
      # trainings
      .state 'app.admin.trainings',
        url: '/admin/trainings'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/trainings/index.html'
            controller: 'TrainingsAdminController'
        resolve:
          trainingsPromise: ['Training', (Training)->
            Training.query().$promise
          ]
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
      .state 'app.admin.trainings_new',
        url: '/admin/trainings/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/trainings/new.html'
            controller: 'NewTrainingController'
        resolve:
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
      .state 'app.admin.trainings_edit',
        url: '/admin/trainings/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/trainings/edit.html'
            controller: 'EditTrainingController'
        resolve:
          trainingPromise: ['Training', '$stateParams', (Training, $stateParams)->
            Training.get(id: $stateParams.id).$promise
          ]
          machinesPromise: ['Machine', (Machine)->
            Machine.query().$promise
          ]
      # events
      .state 'app.admin.events',
        url: '/admin/events'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/events/index.html'
            controller: 'AdminEventsController'
        resolve:
          eventsPromise: ['Event', (Event)->
            Event.query(page: 1).$promise
          ]
          categoriesPromise: ['Category', (Category) ->
            Category.query().$promise
          ]
          themesPromise: ['EventTheme', (EventTheme) ->
            EventTheme.query().$promise
          ]
          ageRangesPromise: ['AgeRange', (AgeRange) ->
            AgeRange.query().$promise
          ]
          priceCategoriesPromise: ['PriceCategory', (PriceCategory) ->
            PriceCategory.query().$promise
          ]
      .state 'app.admin.events_new',
        url: '/admin/events/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/events/new.html'
            controller: 'NewEventController'
        resolve:
          categoriesPromise: ['Category', (Category) ->
            Category.query().$promise
          ]
          themesPromise: ['EventTheme', (EventTheme) ->
            EventTheme.query().$promise
          ]
          ageRangesPromise: ['AgeRange', (AgeRange) ->
            AgeRange.query().$promise
          ]
          priceCategoriesPromise: ['PriceCategory', (PriceCategory) ->
            PriceCategory.query().$promise
          ]
      .state 'app.admin.events_edit',
        url: '/admin/events/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/events/edit.html'
            controller: 'EditEventController'
        resolve:
          eventPromise: ['Event', '$stateParams', (Event, $stateParams)->
            Event.get(id: $stateParams.id).$promise
          ]
          categoriesPromise: ['Category', (Category) ->
            Category.query().$promise
          ]
          themesPromise: ['EventTheme', (EventTheme) ->
            EventTheme.query().$promise
          ]
          ageRangesPromise: ['AgeRange', (AgeRange) ->
            AgeRange.query().$promise
          ]
          priceCategoriesPromise: ['PriceCategory', (PriceCategory) ->
            PriceCategory.query().$promise
          ]
      .state 'app.admin.event_reservations',
        url: '/admin/events/:id/reservations'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/events/reservations.html'
            controller: 'ShowEventReservationsController'
        resolve:
          eventPromise: ['Event', '$stateParams', (Event, $stateParams)->
            Event.get(id: $stateParams.id).$promise
          ]
          reservationsPromise: ['Reservation', '$stateParams', (Reservation, $stateParams)->
            Reservation.query(reservable_id: $stateParams.id, reservable_type: 'Event').$promise
          ]
      # pricing
      .state 'app.admin.pricing',
        url: '/admin/pricing'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/pricing/index.html'
            controller: 'EditPricingController'
        resolve:
          plans: ['Plan', (Plan) ->
            Plan.query().$promise
          ]
          groups: ['Group', (Group) ->
            Group.query().$promise
          ]
          machinesPricesPromise: ['Price', (Price)->
            Price.query(priceable_type: 'Machine', plan_id: 'null').$promise
          ]
          trainingsPricingsPromise: ['TrainingsPricing', (TrainingsPricing)->
            TrainingsPricing.query().$promise
          ]
          trainingsPromise: ['Training', (Training) ->
            Training.query().$promise
          ]
          machineCreditsPromise: ['Credit', (Credit) ->
            Credit.query({creditable_type: 'Machine'}).$promise
          ]
          machinesPromise: ['Machine', (Machine) ->
            Machine.query().$promise
          ]
          trainingCreditsPromise: ['Credit', (Credit) ->
            Credit.query({creditable_type: 'Training'}).$promise
          ]
          couponsPromise: ['Coupon', (Coupon) ->
            Coupon.query().$promise
          ]
          spacesPromise: ['Space', (Space) ->
            Space.query().$promise
          ]
          spacesPricesPromise: ['Price', (Price)->
            Price.query(priceable_type: 'Space', plan_id: 'null').$promise
          ]
          spacesCreditsPromise: ['Credit', (Credit) ->
            Credit.query({creditable_type: 'Space'}).$promise
          ]

      # plans
      .state 'app.admin.plans',
        abstract: true
        resolve:
          prices: ['Pricing', (Pricing) ->
            Pricing.query().$promise
          ]
          groups: ['Group', (Group) ->
            Group.query().$promise
          ]
          partners: ['User', (User) ->
            User.query({role: 'partner'}).$promise
          ]
      .state 'app.admin.plans.new',
        url: '/admin/plans/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/plans/new.html'
            controller: 'NewPlanController'
      .state 'app.admin.plans.edit',
        url: '/admin/plans/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/plans/edit.html'
            controller: 'EditPlanController'
        resolve:
          spaces: ['Space', (Space) ->
            Space.query().$promise
          ]
          machines: ['Machine', (Machine) ->
            Machine.query().$promise
          ]
          plans: ['Plan', (Plan) ->
            Plan.query().$promise
          ]
          planPromise: ['Plan', '$stateParams', (Plan, $stateParams) ->
            Plan.get({id: $stateParams.id}).$promise
          ]
      # coupons
      .state 'app.admin.coupons_new',
        url: '/admin/coupons/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/coupons/new.html'
            controller: 'NewCouponController'
      .state 'app.admin.coupons_edit',
        url: '/admin/coupons/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/coupons/edit.html'
            controller: 'EditCouponController'
        resolve:
          couponPromise: ['Coupon', '$stateParams', (Coupon, $stateParams) ->
            Coupon.get({id: $stateParams.id}).$promise
          ]



      # invoices
      .state 'app.admin.invoices',
        url: '/admin/invoices'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/invoices/index.html'
            controller: 'InvoicesController'
        resolve:
          settings: ['Setting', (Setting)->
            Setting.query(names: "[
                  'invoice_legals',
                  'invoice_text',
                  'invoice_VAT-rate',
                  'invoice_VAT-active',
                  'invoice_order-nb',
                  'invoice_code-value',
                  'invoice_code-active',
                  'invoice_reference',
                  'invoice_logo'
                ]").$promise
          ]
          invoices: [ 'Invoice', (Invoice) ->
            Invoice.list({
              query: { number: '', customer: '', date: null, order_by: '-reference', page: 1, size: 20 }
            }).$promise
          ]
      # members
      .state 'app.admin.members',
        url: '/admin/members'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/members/index.html'
            controller: 'AdminMembersController'
          'groups@app.admin.members':
            templateURL: 'static/makerspace/views/admin/groups/index.html'
            controller: 'GroupsController'
          'tags@app.admin.members':
            templateURL: 'static/makerspace/views/admin/tags/index.html'
            controller: 'TagsController'
          'authentification@app.admin.members':
            templateURL: 'static/makerspace/views/admin/authentications/index.html'
            controller: 'AuthentificationController'
        resolve:
          membersPromise: ['Member', (Member)->
            Member.list({ query: { search: '', order_by: 'id', page: 1, size: 20 } }).$promise
          ]
          adminsPromise: ['Admin', (Admin)->
            Admin.query().$promise
          ]
          groupsPromise: ['Group', (Group)->
            Group.query().$promise
          ]
          tagsPromise: ['Tag', (Tag)->
            Tag.query().$promise
          ]
          authProvidersPromise: ['AuthProvider', (AuthProvider)->
            AuthProvider.query().$promise
          ]

      .state 'app.admin.members_new',
        url: '/admin/members/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/members/new.html'
            controller: 'NewMemberController'
      .state 'app.admin.members_edit',
        url: '/admin/members/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/members/edit.html'
            controller: 'EditMemberController'
        resolve:
          memberPromise: ['Member', '$stateParams', (Member, $stateParams)->
            Member.get(id: $stateParams.id).$promise
          ]
          activeProviderPromise: ['AuthProvider', (AuthProvider) ->
            AuthProvider.active().$promise
          ]
          walletPromise: ['Wallet', '$stateParams', (Wallet, $stateParams)->
            Wallet.getWalletByUser(user_id: $stateParams.id).$promise
          ]
          transactionsPromise: ['Wallet', 'walletPromise', (Wallet, walletPromise)->
            Wallet.transactions(id: walletPromise.id).$promise
          ]
          tagsPromise: ['Tag', (Tag)->
            Tag.query().$promise
          ]
      .state 'app.admin.admins_new',
        url: '/admin/admins/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/admins/new.html'
            controller: 'NewAdminController'


      # authentification providers
      .state 'app.admin.authentication_new',
        url: '/admin/authentications/new'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/authentications/new.html'
            controller: 'NewAuthenticationController'
        resolve:
          mappingFieldsPromise: ['AuthProvider', (AuthProvider)->
            AuthProvider.mapping_fields().$promise
          ]
          authProvidersPromise: ['AuthProvider', (AuthProvider)->
            AuthProvider.query().$promise
          ]
      .state 'app.admin.authentication_edit',
        url: '/admin/authentications/:id/edit'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/authentications/edit.html'
            controller: 'EditAuthenticationController'
        resolve:
          providerPromise: ['AuthProvider', '$stateParams', (AuthProvider, $stateParams)->
            AuthProvider.get(id: $stateParams.id).$promise
          ]
          mappingFieldsPromise: ['AuthProvider', (AuthProvider)->
            AuthProvider.mapping_fields().$promise
          ]


      # statistics
      .state 'app.admin.statistics',
        url: '/admin/statistics'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/statistics/index.html'
            controller: 'StatisticsController'
        resolve:
          membersPromise: ['Member', (Member) ->
            Member.mapping().$promise
          ]
          statisticsPromise: ['Statistics', (Statistics)->
            Statistics.query().$promise
          ]
      .state 'app.admin.stats_graphs',
        url: '/admin/statistics/evolution'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/statistics/graphs.html'
            controller: 'GraphsController'

      # configurations
      .state 'app.admin.settings',
        url: '/admin/settings'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/settings/index.html'
            controller: 'SettingsController'
        resolve:
          settingsPromise: ['Setting', (Setting)->
            Setting.query(names: "[
              'twitter_name',
              'about_title',
              'about_body',
              'about_contacts',
              'home_blogpost',
              'machine_explications_alert',
              'training_explications_alert',
              'training_information_message',
              'subscription_explications_alert',
              'event_explications_alert',
              'space_explications_alert',
              'booking_window_start',
              'booking_window_end',
              'booking_move_enable',
              'booking_move_delay',
              'booking_cancel_enable',
              'booking_cancel_delay',
              'main_color',
              'secondary_color',
              'fablab_name',
              'name_genre',
              'reminder_enable',
              'reminder_delay',
              'visibility_yearly',
              'visibility_others'
            ]").$promise
          ]
          cguFile: ['CustomAsset', (CustomAsset) ->
            CustomAsset.get({name: 'cgu-file'}).$promise
          ]
          cgvFile: ['CustomAsset', (CustomAsset) ->
            CustomAsset.get({name: 'cgv-file'}).$promise
          ]
          faviconFile: ['CustomAsset', (CustomAsset) ->
            CustomAsset.get({name: 'favicon-file'}).$promise
          ]
          profileImageFile: ['CustomAsset', (CustomAsset) ->
            CustomAsset.get({name: 'profile-image-file'}).$promise
          ]

      # OpenAPI Clients
      .state 'app.admin.open_api_clients',
        url: '/open_api_clients'
        views:
          'main@':
            templateURL: 'static/makerspace/views/admin/open_api_clients/index.html'
            controller: 'OpenAPIClientsController'
        resolve:
          clientsPromise: ['OpenAPIClient', (OpenAPIClient)->
            OpenAPIClient.query().$promise
          ]

]