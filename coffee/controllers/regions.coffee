
Angular.controller 'regions', ($scope, $timeout)->

	$timeout () ->

		document.getElementById("regionSearchButton").addEventListener "click", () ->
			search = document.getElementById("regionSearchBox").value
			location.href = "#/region?id=" + search