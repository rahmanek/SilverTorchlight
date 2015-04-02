
Angular.controller 'providerSummary', ($scope, $timeout)->


	$timeout () ->
		document.getElementById("providerSearchButton").addEventListener "click", () ->
			search = document.getElementById("providerSearchBox").value
			location.href = "#/provider?orgId=" + search

	