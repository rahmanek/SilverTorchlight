
Angular.controller 'thce', ($scope, $timeout)->

	$timeout () ->

		document.getElementById("subjectSearchButton").addEventListener "click", () ->
			search = document.getElementById("subjectSearchBox").value
			if search != ""
				location.href = "#/" + search

		thce = document.thce
		document.getElementById("thceInfo").style.visibility = "hidden"
		width = document.getElementById('thceTreemap').offsetWidth
		color = d3.scale.category20c();
		settings = document.settings
		treemap = d3.layout
		.treemap()
		.size [width,500]
		.sticky true
		.value (d) ->
			d.exp13

		divNodes = d3.select("#thceTreemap").selectAll(".node")
		.data(treemap.nodes(thce))
		.enter()
		.append "div"
		.attr "class","node"

		.on "click", (d) ->
			if d.children?
				treemap
				.value (f) ->
					if f.parent? and d.name == f.parent.name
						return f.exp12 
					else
						return 0

				divNodes
				.data treemap.nodes(thce)
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