
Angular.controller 'region', ($scope, $timeout, $routeParams)->

	$timeout () ->

		params = $routeParams

		$.get document.settings.patriotHost + "region?regionId=" + params.id, (data) ->
			if data.directive == "Affirmative"

				$scope.region =
					data: data.results
					description: data.description
				$scope.$apply()

				donutData = []

				for datum in $scope.region.data
					if datum.description == "TME Commercial Inpatient PMPM Dollars" or 
					datum.description == "TME Commercial Outpatient PMPM Dollars" or
					datum.description == "TME Commercial Physician PMPM Dollars" or
					datum.description == "TME Commercial Professional PMPM Dollars" or
					datum.description == "TME Commercial Rx PMPM Dollars" or
					datum.description == "TME Commercial Other PMPM Dollars" or
					datum.description == "TME Commercial Nonclaims PMPM Dollars"
						donutData.push 
							description: datum.description
							value: datum.value
							category: datum.description.split(' ')[2]

					if datum.description == "TME Commercial PMPM Dollars" and
					datum.calendarYear == 2013
						totalTme = datum.value
						console.log datum.value
						$scope.region.donut = 
							name: datum.description
							category: "Total"
							value: Number(totalTme).toLocaleString('en')
							percent: 100

				width = 400
				height = 400
				radius = Math.min(width, height) / 2

				color = d3.scale.category20()

				pie = d3.layout.pie()
				.sort null
				.value (d) ->
					d.value

				arc = d3.svg.arc()
				.innerRadius radius - 100
				.outerRadius radius - 50

				svg = d3.select "#tmeDonut"
				.append "svg"
				.attr "width", width
				.attr "height", height
				.append "g" 
				.attr "transform", "translate(" + width / 2 + "," + height / 2 + ")"

				console.log pie donutData

				path = svg.selectAll "path"
				.data pie donutData
				.enter()
				.append "path"
				.attr "fill", (d, i) ->
					return color i
				.attr "d", arc
				.on "mouseover", (d, i) ->

					document.getElementById("tmeDonutInfo").style.borderColor = color i
					$scope.region.donut =
						name: d.data.description
						category:d.data.category
						value: Number(d.data.value).toLocaleString('en')
						percent: Math.round((d.data.value / totalTme)*10000)/100
					$scope.$apply()
					console.log d.data.value / totalTme

				.on "mouseout", (d) ->
					document.getElementById("tmeDonutInfo").style.borderColor = "#000000"
					$scope.region.donut =
						name: "TME Commercial Inpatient PMPM Dollars"
						category: "Total"
						value: Number(totalTme).toLocaleString('en')
						percent: 100
					$scope.$apply()