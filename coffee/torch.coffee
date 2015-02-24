
Angular = angular.module 'torch', ['ngRoute']

Angular.config ['$routeProvider',($routeProvider) ->

	$routeProvider
		.when '/payer',
			templateUrl: 'payer.html'
			controller: 'payer'

		.when '/region',
			templateUrl: 'region.html'
			controller: 'region'

		.when '/provider',
			templateUrl: 'provider.html'
			controller: 'provider'

		.otherwise
			redirectTo: '#'
	]
