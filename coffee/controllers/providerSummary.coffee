
Angular.controller 'providerSummary', ($scope, $timeout, $sce)->


	$timeout () ->
		document.getElementById("providerSearchButton").addEventListener "click", () ->
			search = document.getElementById("providerSearchBox").value
			location.href = "#/provider?orgId=" + search

		$.get document.settings.patriotHost + "provider?description=Revenue Dollars&year=2013", (requestRevenue) ->
			$.get document.settings.patriotHost + "provider?description=Margin Dollars&year=2013", (requestMargin) ->
				$.get document.settings.patriotHost + "provider?description=RP Quintile&year=2013", (requestRp) ->
					providers = requestRevenue.results.detail

					for provider in providers
						provider.providerProfile = "#/provider?orgId=" + provider.orgId
						provider.orgIdNum = provider.orgId * 1

						for providerData in requestMargin.results.data
							if provider.orgId == providerData.providerId
								provider.margin = Math.round(providerData.value*10000)/100

						for providerData in requestRevenue.results.data
							if provider.orgId == providerData.providerId
								if provider.revenue == "" then provider.revenue = "0"
								provider.revenueNum = providerData.value * 1
								provider.revenue = Number(providerData.value).toLocaleString('en')

						for providerData in requestRp.results.data
							if provider.orgId == providerData.providerId
								provider.rp = providerData.value
								rpStr = ""
								for rpRank in [1..provider.rp]
									rpStr += "$"
								provider.priceLevel = rpStr
								provider.priceLevelNum = rpRank * 1
					sortState = 1
					$scope.providerSummary =
						providers: providers
						sortState: sortState
					$scope.$apply()

					console.log providers
					sortHospitals = () ->
						that = @
						providers.sort (a,b) ->
							if a[that.id] > b[that.id] then return sortState
							else if a[that.id] < b[that.id] then return sortState * -1
							else return 0

						sortState *= -1

						$scope.providerSummary =
							providers: providers
						$scope.$apply()

					sortCarrots = document.getElementsByClassName("providerSummary")

					for carrot in sortCarrots
						carrot.addEventListener "click", sortHospitals
