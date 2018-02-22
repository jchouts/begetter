'use strict'

##
# Navigation controller. List the links availables in the left navigation pane and their icon.
##
Application.Controllers.controller "MainNavController", ["$scope", "$location", "$cookies", ($scope, $location, $cookies) ->

  ## Common links (public application)
  $scope.navLinks = [
    {
      state: 'app.public.home'
      linkText: 'Home'
      linkIcon: 'home'
    }

    {
      state: 'app.public.machines_list'
      linkText: 'Reserve A Machine'
      linkIcon: 'cogs'
    }
    {
      state: 'app.public.trainings_list'
      linkText: 'Training'
      linkIcon: 'graduation-cap'
    }
    {
      state: 'app.public.events_list'
      linkText: 'Events'
      linkIcon: 'tags'
    }
    {
      state: 'app.public.calendar'
      linkText: 'Calendar'
      linkIcon: 'calendar'
    }
    {
      state: 'app.public.projects_list'
      linkText: 'Project Gallery'
      linkIcon: 'th'
    }

  ]

  unless Fablab.withoutPlans
    $scope.navLinks.push({
        state: 'app.public.plans'
        linkText: 'Subscriptions'
        linkIcon: 'credit-card'
    })

  unless Fablab.withoutSpaces
    $scope.navLinks.splice(3, 0, {
      state: 'app.public.spaces_list'
      linkText: 'Reserve a Space'
      linkIcon: 'rocket'
    })


  Fablab.adminNavLinks = Fablab.adminNavLinks || []
  adminNavLinks = [
    {
      state: 'app.admin.trainings'
      linkText: 'Training Monitoring'
      linkIcon: 'graduation-cap'
    }
    {
      state: 'app.admin.calendar'
      linkText: 'Manage the Calendar'
      linkIcon: 'calendar'
    }
    {
      state: 'app.admin.members'
      linkText: 'Manage Users'
      linkIcon: 'users'
    }
    {
      state: 'app.admin.invoices'
      linkText: 'Manage Invoices'
      linkIcon: 'file-pdf-o'
    }
    {
      state: 'app.admin.pricing'
      linkText: 'Subscriptions and Prices'
      linkIcon: 'money'
    }
    {
      state: 'app.admin.events'
      linkText: 'Manage Events'
      linkIcon: 'tags'
    }
    {
      state: 'app.public.machines_list'
      linkText: 'Manage Machines'
      linkIcon: 'cogs'
    }
    {
      state: 'app.admin.project_elements'
      linkText: 'Manage Project Elements'
      linkIcon: 'tasks'
    }
    {
      state: 'app.admin.statistics'
      linkText: 'statistics'
      linkIcon: 'bar-chart-o'
    }
    {
      state: 'app.admin.settings'
      linkText: 'Customization'
      linkIcon: 'gear'
    }
    {
      state: 'app.admin.open_api_clients'
      linkText: 'Open API Clients'
      linkIcon: 'cloud'
    }
  ].concat(Fablab.adminNavLinks)

  $scope.adminNavLinks = adminNavLinks

  unless Fablab.withoutSpaces
    $scope.adminNavLinks.splice(7, 0, {
      state: 'app.public.spaces_list'
      linkText: 'Manage Spaces'
      linkIcon: 'rocket'
    })
]
