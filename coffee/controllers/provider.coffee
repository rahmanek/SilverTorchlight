
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
				stats = {}
				payerArray = []

				for datum in request.results.data
					if datum.description == "Margin Dollars" and datum.calendarYear == 2013 then stats.margin = Math.round(datum.value*10000)/100
					if datum.description == "Revenue Dollars" and datum.calendarYear == 2013 then stats.revenue = Number(datum.value).toLocaleString('en')

					buildRp = (rpType, datum) ->
						if datum.value == "0" then datum.value = ""
						match = false
						for payer, i in payerArray
							if payer.name == datum.description.split(" ")[0]
								match = true
								payer[rpType] = datum
								break
						if match == false
							payerObj = {}
							payerObj.name = datum.description.split(" ")[0]
							payerObj[rpType] = datum

							payerArray.push payerObj

					if datum.description.split(" ")[1] == "Blended" then buildRp("blended", datum)
					if datum.description.split(" ")[1] == "Outpatient" then buildRp("outpatient", datum)
					if datum.description.split(" ")[1] == "Inpatient" then buildRp("inpatient", datum)
				$scope.provider.payers = payerArray
				$scope.provider.stats = stats

				$scope.$apply()
			$.get document.settings.patriotHost + "region?description=", (request2) ->
				for detail in request2.results.detail
					if detail.longName == request.results.detail.region
						$scope.provider.regionLink = $sce.trustAsHtml("<a href=\"#/region?regionId=" + detail.regionId + "\">" + detail.longName + "</a>")
				$scope.$apply()

