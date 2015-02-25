
Angular.controller 'search', ($scope, $timeout)->

	$timeout () ->

		document.getElementById("searchButton").addEventListener "click", () ->
			search = document.getElementById("searchBox").value
			type = document.getElementById("searchType").value
			location.href = "#/" + type + "?id=" + search