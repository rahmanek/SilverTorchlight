
Angular.controller 'subjectSummary', ($scope, $timeout)->

	$timeout () ->
		document.getElementById("subjectSearchButton").addEventListener "click", () ->
			search = document.getElementById("subjectSearchBox").value
			if search != ""
				location.href = "#/" + search