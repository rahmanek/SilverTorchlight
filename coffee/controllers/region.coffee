
Angular.controller 'region', ($scope, $timeout, $routeParams)->


	$scope.region = 
		view: 'profile'

	buildDonut = (data) ->

		# Prepare Donut Data

		donutData = []

		for datum in data
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
				$scope.region.donut = 
					name: datum.description
					category: "Total"
					value: Number(totalTme).toLocaleString('en')
					percent: 100

		# Prepare Donut
		dim =  document.getElementById('tmeDonut').offsetWidth - 30
		radius = dim / 2

		color = d3.scale.category20()
		pie = d3.layout.pie()
		.sort null
		.value (d) ->
			d.value

		arc = d3.svg
			.arc()
			.innerRadius radius - 55
			.outerRadius radius - 5

		svg = d3.select "#tmeSvg"
			.attr "width", dim
			.attr "height", dim

		svgG = d3.select "#tmeG"
			.attr "transform", "translate(" + dim / 2 + "," + dim / 2 + ")"


		path = svgG.selectAll "path"
			.data pie donutData
			.enter()
			.append "path"
			.attr "fill", (d, i) ->
				return color i
			.attr "d", arc
			.on "mouseover", (d, i) ->

				$scope.region.donut =
					name: d.data.description
					category:d.data.category
					value: Number(d.data.value).toLocaleString('en')
					percent: Math.round((d.data.value / totalTme)*10000)/100
				$scope.$apply()

		.on "mouseout", (d) ->

			$scope.region.donut =
				name: "TME Commercial Inpatient PMPM Dollars"
				category: "Total"
				value: Number(totalTme).toLocaleString('en')
				percent: 100
			$scope.$apply()


	listPayers = (data) ->

		payerMembers = []
		for datum in data
			if datum.description == "Region Member Count"
				regionCount = datum.value

		for datum in data
			if datum.description == "Aetna Member Count" or 
			datum.description == "BCBS Member Count" or
			datum.description == "BMC Member Count" or
			datum.description == "Celticare Member Count" or
			datum.description == "Connecticut General Member Count" or
			datum.description == "Fallon Member Count" or
			datum.description == "HPHC Member Count" or
			datum.description == "HNE Member Count" or
			datum.description == "Neighborhood Member Count" or
			datum.description == "Network Member Count" or
			datum.description == "Tufts Member Count" or
			datum.description == "United Member Count" or
			datum.description == "Cigna Member Count" or
			datum.description == "Cigna East Member Count"
				datum.name = datum.description.split(" ")[0]
				datum.percent = Math.round(datum.value / regionCount * 10000)/100
				payerMembers.push datum

		payerMembers.sort (a,b) ->
			return b.value-a.value

		return payerMembers.slice(0,5)

	buildGraph = (request) ->
		# Prepare Graph Data
		data = []

		for record in request
			if record.description == "TME Commercial PMPM Dollars"
				if record.calendarYear == 2010 or
				record.calendarYear == 2011 or
				record.calendarYear == 2012 or
				record.calendarYear == 2013
					data.push
						calendarYear: record.calendarYear
						value: record.value 

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

		data.forEach (d) ->
			d.calendarYear = +d.calendarYear
			d.value = +d.value

		x.domain d3.extent data, (d) ->
			d.calendarYear

		y.domain d3.extent data, (d) ->
			d.value

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

		svg.append("path")
			.datum(data)
			.attr("class", "line")
			.attr "d", line
			.style "stroke", (f) ->
				return "green"


	buildTreemap = () ->
		color = d3.scale.category20c()
		tme = document.thce
		dim = document.getElementById('treemap').offsetWidth - 30
		settings = document.settings
		treemap = d3.layout
		.treemap()
		.size [dim,500]
		.sticky true
		.value (d) ->
			d.exp13

		divNodes = d3.select("#treemap").selectAll(".node")
		.data(treemap.nodes(tme))
		.enter()
		.append "div"
		.on "click", (d) ->
			if d.children?
				treemap
				.value (f) ->
					if f.parent? and d.name == f.parent.name
						return f.exp12 
					else
						return 0

				divNodes
				.data treemap.nodes(tme)
				.transition()
				.duration(1500)
				.style "visibility", (f) ->
					if (f.parent? and f.parent.name == d.name)
						return "visible"
					else if f.depth == d.depth
						return "visible"
					else
						return "hidden"
				.style "left", (d) -> return d.x + "px"
				.style "top", (d) -> return d.y + "px"
				.style "width", (d) -> return d.dx + "px"
				.style "height", (d) -> return d.dy + "px"

		.on "mouseover", (d) ->
			$scope.thce = 
				name: d.name
				parentName: d.parent.name
				exp12: Number(d.exp12).toLocaleString('en')
				exp13: Number(d.exp13).toLocaleString('en')
				percChange: Math.round((d.exp13/d.exp12-1)*1000)/1000
			$scope.$apply()
			document.getElementById("thceInfo").style.visibility = "visible"
		.on "mouseout", (d) ->
			document.getElementById("thceInfo").style.visibility = "hidden"
		.attr "class","node"
		.style "position","absolute"
		.style "display","table-cell"
		.style "left", (d) -> return d.x + "px"
		.style "top", (d) -> return d.y + "px"
		.style "width", (d) -> return d.dx + "px"
		.style "height", (d) -> return d.dy + "px"
		.style "border", (d) ->	return "1px solid white"
		.style "visibility", (d) ->
			if d.depth == 1
				return "visible"
			else
				return "hidden"
		.style "background-color", (d) ->
			colorRatio = d.exp13/d.exp12

			fRed = Math.round(settings.primary1.red * colorRatio * colorRatio * colorRatio).toString(16)
			if fRed.length == 1
				fRed = "0" + fRed

			fGreen = Math.round(settings.primary1.green * colorRatio * colorRatio * colorRatio).toString(16)
			if fGreen.length == 1
				fGreen += "0" + fGreen

			fBlue = Math.round(settings.primary1.blue * colorRatio * colorRatio * colorRatio).toString(16)
			if fBlue.length == 1
				fBlue += "0" + fRed

			return "##{fRed}#{fGreen}#{fBlue}"
			if d.children? == false
				return color d.parent.name
		.style "color", "#CCCCCC"

		divNodes
		.append "span"
		.style "width", "100%"
		.style "white-space", "nowrap"
		.style "text-overflow","ellipsis"
		.style "font-size", "10px"
		.style "overflow", "hidden"
		.style "margin-top", "-5px"
		.style "position", "absolute"
		.style "text-align", "center"
		.style "top", "50%"
		.attr "class","nodeText"
		.text (d) ->
			return d.name

	$timeout () ->

		document.getElementById("regionSearchButton").addEventListener "click", () ->
			search = document.getElementById("regionSearchBox").value
			if search != ""
				location.href = "#/region?regionId=" + search

		$.get document.settings.patriotHost + "region?regionId=" + $routeParams.regionId, (request) ->
			if request.directive == "Affirmative"

				data = request.results.data

				if $routeParams.regionId != "0"
					document.getElementById("mapSvg")
						.getSVGDocument()
						.getElementById("region" + $routeParams.regionId)
						.style
						.fill = document.settings.primary1.hex
				$scope.region.detail = request.results.detail
				$scope.region.data = data

				$scope.region.payerMembers = listPayers(data)
				buildDonut(data)
				buildGraph(data)
				if $routeParams.regionId == "0" then buildTreemap()

				d3.select(window).on 'resize', () ->
					buildDonut(data)

				for datum in data
					if datum.description == "Adjusted Gross Income Dollars"
						$scope.region['income'] = Number(datum.value).toLocaleString('en')
					if datum.description == "APM Commercial Percent"
						$scope.region['apmPercent'] = datum.value
					if datum.description == "FFS Commercial Percent"
						$scope.region['ffsPercent'] = datum.value
					if datum.description == "Acute Hospital Count"
						$scope.region['acuteCount'] = datum.value
					if datum.description == "Residents to Statewide Percent"
						$scope.region['residentPercent'] = datum.value					
					if datum.description == "Membership to Statewide Percent"
						$scope.region['memberPercent'] = datum.value
					if datum.description == "Public Coverage Percent"
						$scope.region['publicCoverage'] = Math.round(datum.value * 10000)/100
					if datum.description == "Private Coverage Percent"
						$scope.region['privateCoverage'] = Math.round(datum.value * 10000)/100
					if datum.description == "No Coverage Percent"
						$scope.region['noCoverage'] = Math.round(datum.value * 10000)/100
				$scope.$apply()
				$.get document.settings.patriotHost + "region?description=", (request) ->
					$scope.region.detailList = request.results.detail
					$scope.$apply()
				$.get document.settings.patriotHost + "provider?region=" + $scope.region.detail.longName, (request) ->
					$scope.region.hospitalList = request.results.detail
					$scope.$apply()