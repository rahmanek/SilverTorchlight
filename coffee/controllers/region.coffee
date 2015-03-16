
Angular.controller 'region', ($scope, $timeout, $routeParams)->


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


	listPayers = () ->

		payerMembers = []

		for datum in $scope.region.data
			if datum.description == "Region Member Count"
				regionCount = datum.value

		for datum in $scope.region.data
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
						date: record.calendarYear
						close: record.value 

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
			x d.date
		.y (d) ->
			y d.close
		
		# Modify DOM
		svg = d3.select("#tmeGraph")
			.append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")")

		data.forEach (d) ->
			d.date = +d.date
			d.close = +d.close

		x.domain d3.extent data, (d) ->
			d.date

		y.domain d3.extent data, (d) ->
			d.close

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


	$timeout () ->

		$scope.regionTab = 1

		document.getElementById("regionSearchButton").addEventListener "click", () ->
			search = document.getElementById("regionSearchBox").value
			location.href = "#/region?id=" + search

		$.get document.settings.patriotHost + "region?regionId=" + $routeParams.id, (request) ->
			if request.directive == "Affirmative"

				detail = request.detail
				data = request.results

				$scope.region =
					detail: detail
					data: data

				$scope.region.payerMembers = listPayers()
				buildDonut(data)
				buildGraph(data)

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
				$scope.$apply()