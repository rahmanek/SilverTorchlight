
Angular.controller 'provider', ($scope, $timeout)->

	$timeout () ->

		$scope.payer = "provider"
		console.log $scope.payer
	