
Angular.controller 'service', ($scope, $timeout, $routeParams, $sce)->


	$timeout () ->

		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			location.href = "#/service?serviceCode=" + search

		if $routeParams.serviceCode? then dataRoute = "serviceCode=" + $routeParams.serviceCode
		else if $routeParams.cat4? then dataRoute = "cat4=" + $routeParams.cat4
		else if $routeParams.cat3? then dataRoute = "cat3=" + $routeParams.cat3
		else if $routeParams.cat2? then dataRoute = "cat2=" + $routeParams.cat2
		else if $routeParams.cat1? then dataRoute = "cat1=" + $routeParams.cat1

		path = document.settings.patriotHost + 'service?' + dataRoute

		$.get path + "&year=2012", (request12) ->
			$.get path + "&year=2011", (request11) ->			
				if request12.directive == "Affirmative" and request11.directive == "Affirmative"
					reqData = []
					for element in request12.results.data 
						reqData.push element
					for element in request11.results.data
						reqData.push element
					$scope.service =
						detail: request12.results.detail
						data: request12.results.data
					stats = {}
					for datum in reqData
						if datum.description == "Top 3 Payer Payments" and datum.year == "2012"
							stats.payments12 = datum.value
							stats.payments12View = Number(Math.round(datum.value)).toLocaleString('en')
						if datum.description == "Top 3 Payer Claims" and datum.year == "2012"
							stats.claims12 = datum.value
							stats.claims12View = Number(datum.value).toLocaleString('en')
						if datum.description == "Top 3 Payer Payments" and datum.year == "2011"
							stats.payments11 = datum.value
						if datum.description == "Top 3 Payer Claims" and datum.year == "2011"
							stats.claims11 = datum.value

					stats.paymentsChange = Math.round(((stats.payments12 / stats.payments11) - 1) * 100 * 100) / 100
					stats.claimsChange = Math.round(((stats.claims12 / stats.claims11) - 1) * 100 * 100) / 100
					stats.averageRate12 =  Number(Math.round(stats.payments12 / stats.claims12 * 100) / 100).toFixed(2)
					stats.averageRate11 = Math.round(stats.payments11 / stats.claims11* 100) / 100
					stats.averageRateChange = Math.round(((stats.averageRate12 / stats.averageRate11) - 1) * 100 * 100) / 100
					$scope.service.stats = stats


					$scope.service.cat1Link = $sce.trustAsHtml("<a href=\"#/service?cat1=" + $scope.service.detail.cat1 + "\">" + $scope.service.detail.cat1 + "</a>")
					$scope.service.cat2Link = $sce.trustAsHtml("<a href=\"#/service?cat2=" + $scope.service.detail.cat2 + "\">" + $scope.service.detail.cat2 + "</a>")
					$scope.service.cat3Link = $sce.trustAsHtml("<a href=\"#/service?cat3=" + $scope.service.detail.cat3 + "\">" + $scope.service.detail.cat3 + "</a>")
					$scope.service.cat4Link = $sce.trustAsHtml("<a href=\"#/service?cat4=" + $scope.service.detail.cat4 + "\">" + $scope.service.detail.cat4 + "</a>")
					$scope.service.view = "profile"
					$scope.$apply()
