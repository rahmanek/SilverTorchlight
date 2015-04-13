
Angular.controller 'serviceSummary', ($scope, $timeout, $routeParams, $sce)->

	$timeout () ->

		document.getElementById("serviceSearchButton").addEventListener "click", () ->
			search = document.getElementById("serviceSearchBox").value
			location.href = "#/service?serviceCode=" + search

		$scope.service = 
			view: 'summary'
		$scope.serviceSummary = {}
		$scope.$apply()

		$.get document.settings.patriotHost + "service?catMap=true&baseCat=true", (request) ->

			$scope.serviceSummary =
				cat1List: request.results.cat1

			$scope.$apply()

			setList = (level, results) ->
				if level == 5 then levelStr = "serviceCode"
				else levelStr = "cat" + level
				for category, i in results[levelStr]
					document.getElementById(i + "Cat" + level + "Button").addEventListener "click", (e) ->
						$scope.serviceSummary.currentSelection = e.currentTarget.dataset.catname
						if level == 5 then urlQuery = "serviceCode"
						else urlQuery = "cat" + level 


						path = "<a href=\"#/service?" + urlQuery + "=" + e.currentTarget.dataset.catname + "\">More Information</a>"
						$scope.serviceSummary.infoLink = $sce.trustAsHtml(path)
						for result in $scope.serviceSummary["cat" + level + "List"]
							classElements = document.getElementsByClassName "cat" + level + "Class"
							for element in classElements
								element.classList.remove "active"
						$scope.$apply()
						e.currentTarget.className += " active"
						if level != 5
							for j in [level..4]
								$scope.serviceSummary["cat" + (j+1) + "List"] = []
								$scope.$apply()
							$.get document.settings.patriotHost + "service?catMap=true&cat" + level + "=" + e.currentTarget.dataset.catname, (request) ->
								if level == 4 then requestStr = "serviceCode"
								else requestStr = "cat" + (level+1)

								$scope.serviceSummary["cat" + (level+1) + "List"] = request.results[requestStr]
								$scope.$apply()
								setList(level+1,request.results)

			setList(1, request.results)