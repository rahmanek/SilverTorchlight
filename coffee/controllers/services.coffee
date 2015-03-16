
Angular.controller 'services', ($scope, $timeout, $routeParams)->

	$timeout () ->
		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			location.href = "#/service?serviceCode=" + search

		$.get document.settings.patriotHost + "service?serviceCode=" + $routeParams.code, (request) ->
			if request.directive == "Affirmative"
				console.log "It's a go!"
