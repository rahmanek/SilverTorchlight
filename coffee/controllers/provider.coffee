
Angular.controller 'provider', ($scope, $timeout, $routeParams, $sce)->

	$timeout () ->

		$scope.provider = 
			view: "profile"
		$scope.$apply()

		document.getElementById("providerSearchButton").addEventListener "click", () ->
			search = document.getElementById("providerSearchBox").value
			location.href = "#/provider?orgId=" + search

		$scope.payer = "provider"
		console.log $scope.payer

		$.get document.settings.patriotHost + "provider?orgId=" + $routeParams.orgId, (request) ->
			if request.directive == "Affirmative"
				$scope.provider.detail = request.results.detail
				$scope.$apply()
			$.get document.settings.patriotHost + "region?description=", (request2) ->
				console.log request2.results.detail
				for detail in request2.results.detail
					if detail.longName == request.results.detail.region
						console.log detail.regionId
						$scope.provider.regionLink = $sce.trustAsHtml("<a href=\"#/region?regionId=" + detail.regionId + "\">" + detail.longName + "</a>")
				$scope.$apply()