
Angular.controller 'rp', ($scope, $timeout, $sce)->

	$timeout () ->
		hospitals = document.hospitals
		document.getElementById("subjectSearchButton").addEventListener "click", () ->
			search = document.getElementById("subjectSearchBox").value
			if search != ""
				location.href = "#/" + search

		settings = document.settings

		$scope.hProfile =
			hSelect: (e) ->
				document.getElementById("infoBody").style.visibility="visible"
				$scope.hName = e.target.toGeoJSON().properties.name
				$scope.hCity = e.target.toGeoJSON().properties.city
				$scope.hRp = Math.round(e.target.toGeoJSON().properties.rp*100)/100
				$scope.hStreet = e.target.toGeoJSON().properties.street
				$scope.hRevenue = Math.round(e.target.toGeoJSON().properties.revenue*100)/100
				$scope.hExpense = Math.round(e.target.toGeoJSON().properties.expense*100)/100
				$scope.hStaffedBeds = Math.round(e.target.toGeoJSON().properties.staffedBeds)
				$scope.hZip = e.target.toGeoJSON().properties.zip
				$scope.profileLink = $sce.trustAsHtml("<a href=\"http://chiamass.gov/assets/docs/r/hospital-profiles/2012/" + e.target.toGeoJSON().properties.hospLinkId + ".pdf\">Hospital Profile</a>")
				$scope.$apply()

		# Mapbox
		L.mapbox.accessToken = document.config.mbToken

		map = L.mapbox.map 'map', 'rahmanek.xlfiumuk',
			zoomControl: false
		.setView([42.1, -71.7], 8)

		map.dragging.disable()
		map.touchZoom.disable()
		map.doubleClickZoom.disable()
		map.scrollWheelZoom.disable()

		hospitalLayers = L.geoJson hospitals,
			pointToLayer: (feature, latLng) ->
				L.circle [latLng.lng,latLng.lat],700
				
			style: (feature) ->
				colorAdj = Math.round(feature.properties.rp*2.55).toString(16)
				if colorAdj.length == 1
					colorAdj = "0" + colorAdj
				color = "\##{colorAdj}#{colorAdj}#{colorAdj}"

				vectorStyle =
					fillColor: color
					color: color
					weight: 1
					opacity: 1
					fillOpacity: 0.8

				return vectorStyle

			onEachFeature: (feature, layer) ->
				layer.on 'click', (e) ->
					$scope.hProfile.hSelect(e)
					
		.addTo map
