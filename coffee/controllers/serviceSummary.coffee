
Angular.controller 'serviceSummary', ($scope, $timeout, $routeParams)->

	$timeout () ->
		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			location.href = "#/service?serviceCode=" + search

		$scope.service = 
			view: 'summary'
		$scope.$apply()
