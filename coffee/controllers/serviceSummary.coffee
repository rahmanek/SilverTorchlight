
Angular.controller 'serviceSummary', ($scope, $timeout, $routeParams)->

	$timeout () ->

		updatePrice = () ->
			console.log 'hello'
		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			location.href = "#/service?serviceCode=" + search

		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			console.log 'ca'

		$scope.service = 
			view: 'summary'
		$scope.serviceSummary = {}
		$scope.$apply()
		$.get document.settings.patriotHost + "service?catMap=true", (request) ->

			active = 
				cat1: null
				cat2: null
				cat3: null
				cat4: null

			catLister = (level) ->
				levelStr = "cat" + level 
				if level == 5 then levelStr == 'code'

				listArray = []
				for code in request.results
					i=true
					for addedCode in listArray
						if code[levelStr] == addedCode[levelStr]
							i=false
					if i == true and code[levelStr] != ""
						listArray.push code

				finalArray = []
				for item in listArray
					for i in [1..level]
						if item["cat" + i] == active["cat" + i] then finalArray.push item
				$scope.serviceSummary[levelStr + "List"] = finalArray

			active.cat1 = "Professional"
			catLister(1)
			# catLister("cat2")
			$scope.$apply()