
Angular.controller 'regionSummary', ($scope, $timeout)->

	activateRegion = (d) ->
		for region in detail
			if d[0].regionId == region.regionId
				longName = region.longName
		$scope.regionSummary.expense = d
		$scope.regionSummary.longName = longName


		$scope.$apply()

		d3.selectAll(".line")
		.style "stroke", (f) ->
			if f[0].regionId == d[0].regionId then return "purple"
			if f[0].regionId == "0" then return "green"
			else return "#E3E3E3"

	buildGraph = (data, detail) ->

		# Prepare Graph Components
		margin =
			top: 20
			right: 40
			bottom: 30
			left: 50

		width = document.getElementById('tmeGraph').offsetWidth - margin.left - margin.right
		height = width * .618
		parseDate = d3.time.format("%Y").parse
		x = d3.scale.linear().range([ 0, width ])
		y = d3.scale.linear().range([ height, 0 ])
		xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(4).tickFormat(d3.format())
		yAxis = d3.svg.axis().scale(y).orient("left")
		line = d3.svg.line().x (d) ->
			x d.calendarYear
		.y (d) ->
			y d.value
		
		# Modify DOM
		svg = d3.select("#tmeGraph")
			.append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")")

		xValues = []
		yValues = []
		for datum in data
			for element in datum
				xValues.push element.calendarYear
				yValues.push element.value

		x.domain d3.extent xValues
		y.domain d3.extent yValues

		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
			.call xAxis

		svg.append("g")
			.attr("class", "y axis")
			.call(yAxis)
			.append("text")
			.attr("transform", "rotate(-90)")
			.attr("y", 6)
			.attr("dy", ".71em")
			.style("text-anchor", "end")
			.text "TME PMPM($)"


		activateRegion = (d) ->
			for region in detail
				if d[0].regionId == region.regionId
					longName = region.longName
			d.sort (a,b) ->
				b.calendarYear - a.calendarYear
			$scope.regionSummary.expense = d
			$scope.regionSummary.longName = longName

			$scope.$apply()

			d3.selectAll(".line")
			.style "stroke", (f) ->
				if f[0].regionId == d[0].regionId then return "purple"
				if f[0].regionId == "0" then return "green"
				else return "#E3E3E3"

		for element in data
			graphLines = svg.append "path"
				.datum element
				.attr "class", "line"
				.style "stroke", (d) ->
					if d[0].regionId == "0" then return "green"
					return "#E3E3E3"
				.attr "d", line

				.on "mouseover", activateRegion

			tiles = d3.select("#regionListing")
				.append "div"
		return svg


	$timeout () ->

		document.getElementById("regionSearchButton").addEventListener "click", () ->
			search = document.getElementById("regionSearchBox").value
			if search != ""
				location.href = "#/region?regionId=" + search

		$scope.region = 
			view: 'summary'
		$scope.regionSummary = {}


		$.get document.settings.patriotHost + "region?description=TME Commercial PMPM Dollars", (request) ->
			detail = request.results.detail
			$scope.region.detailList = request.results.detail
			$scope.$apply()

			lineArray = []

			for line in [0..8]
				lineComponent = []
				for datum in request.results.data
					regionId = datum.regionId * 1
					if regionId == line
						datum.calendarYear = +datum.calendarYear
						datum.value = +datum.value
						lineComponent.push datum
				lineArray.push lineComponent

			svg = buildGraph(lineArray,detail)

			regionList = d3.select("#regionList")

			for region in detail
				region.url = "region?regionId=" + region.regionId

			regionListDivs = regionList.selectAll "div"
				.data lineArray
				.enter()
				.append "div"

			regionListDivs
				.attr "class", "list-group-item"
				.append "a"
				.attr "href", (d) ->
					return "#/region?regionId=" + d[0].regionId
				.text (d) ->
					for region in detail 
						if d[0].regionId == region.regionId
							return region.longName
				.on "mouseover", (d) ->
					activateRegion(d)
