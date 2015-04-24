
Angular = angular.module 'torchlight', ['ngRoute']

Angular.config ['$routeProvider',($routeProvider) ->

	$routeProvider

		.when '/service',
			templateUrl: 'service.html'
			controller: 'service'

		.when '/serviceSummary',
			templateUrl: 'serviceSummary.html'
			controller: 'serviceSummary'

		.when '/region',
			templateUrl: 'region.html'
			controller: 'region'

		.when '/regionSummary',
			templateUrl: 'regionSummary.html'
			controller: 'regionSummary'

		.when '/provider',
			templateUrl: 'provider.html'
			controller: 'provider'

		.when '/providerSummary',
			templateUrl: 'providerSummary.html'
			controller: 'providerSummary'

		.when '/maps',
			templateUrl: 'maps.html'

		.when '/tools',
			templateUrl: 'tools.html'
			controller: 'tools'

		.when '/home',
			templateUrl: 'home.html'
			controller: 'home'

		.when '/subjectSummary',
			templateUrl: 'subjectSummary.html'
			controller: 'subjectSummary'
			
		.when '/rp',
			templateUrl: 'rp.html'
			controller: 'rp'
			
		.when '/thce',
			templateUrl: 'thce.html'
			controller: 'thce'

		.when '/',
			templateUrl: 'home.html'
			controller: 'home'

		.otherwise
			redirectTo: '#/home'
	]


$ () ->
	$(".dropdown").hover () ->
			$('.dropdown-menu', this).stop( true, true ).fadeIn(100)
			$(this).toggleClass('open')
			$('b', this).toggleClass("caret caret-up")
		, () ->
			$('.dropdown-menu', this).stop( true, true ).fadeOut(100)
			$(this).toggleClass('open')
			$('b', this).toggleClass("caret caret-up")
