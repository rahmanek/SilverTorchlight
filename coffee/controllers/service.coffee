
Angular.controller 'service', ($scope, $timeout, $routeParams)->


	$timeout () ->
		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			if search.length == 3
				location.href = "#/service?betosCode=" + search
			else
				location.href = "#/service?serviceCode=" + search

		if $routeParams.serviceCode? then path = document.settings.patriotHost + "service?serviceCode=" + $routeParams.serviceCode
		if $routeParams.betosCode? then path = document.settings.patriotHost + "betos?betosCode=" + $routeParams.betosCode
		
		$.get path, (request) ->
			if request.directive == "Affirmative"
				$scope.service = request.results
				stats = {}
				for datum in request.results.data
					if datum.description == "Top 3 Payer Payments" and datum.year == 2012
						stats.payments12 = datum.value
						stats.payments12View = Number(Math.round(datum.value)).toLocaleString('en')
					if datum.description == "Top 3 Payer Payments" and datum.year == 2011
						stats.payments11 = datum.value
					if datum.description == "Top 3 Payer Claims" and datum.year == 2012
						stats.claims12 = datum.value
						stats.claims12View = Number(datum.value).toLocaleString('en')
					if datum.description == "Top 3 Payer Claims" and datum.year == 2011
						stats.claims11 = datum.value
				stats.paymentsChange = Math.round(((stats.payments12 / stats.payments11) - 1) * 100 * 100) / 100
				stats.claimsChange = Math.round(((stats.claims12 / stats.claims11) - 1) * 100 * 100) / 100
				stats.averageRate12 =  Number(Math.round(stats.payments12 / stats.claims12 * 100) / 100).toFixed(2)
				stats.averageRate11 = Math.round(stats.payments11 / stats.claims11* 100) / 100
				stats.averageRateChange = Math.round(((stats.averageRate12 / stats.averageRate11) - 1) * 100 * 100) / 100
				$scope.service.stats = stats
				$scope.$apply()
