
Angular.controller 'region', ($scope, $timeout, $routeParams)->

	$timeout () ->

		params = $routeParams

		$.get document.settings.patriotHost + "region?regionId=" + params.id, (data) ->
			if data.directive == "Affirmative"

				$scope.region =
					data: data.results
					description: data.description
				$scope.$apply()


				dataset = apples: [53245, 28479, 19697, 24037, 40245]


				width = 400
				height = 400
				radius = Math.min(width, height) / 2

				color = d3.scale.category20()

				pie = d3.layout.pie()
				.sort(null)

				arc = d3.svg.arc()
				.innerRadius(radius - 100)
				.outerRadius(radius - 50)

				svg = d3.select("body").append("svg")
				.attr("width", width)
				.attr("height", height)
				.append("g")
				.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

				path = svg.selectAll("path")
				.data(pie(dataset.apples))
				.enter().append("path")
				.attr "fill", (d, i) ->
					return color(i)
				.attr("d", arc)
