
Angular.controller 'region', ($scope, $timeout)->

	$timeout () ->

		$scope.payer = "provider"
		console.log $scope.payer
	