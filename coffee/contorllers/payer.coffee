
Angular.controller 'payer', ($scope, $timeout)->

	$timeout () ->

		$scope.payer = "payer"
		console.log $scope.payer
	