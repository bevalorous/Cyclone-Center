Step = require './base-step'
detailsTemplate = require '../../views/classify-steps/reveal'
$ = window.jQuery
Leaflet = window.L
Api = require 'zooniverse/lib/api'

LEAFLET_API_KEY = '21a5504123984624a5e1a856fc00e238' # Brian's
DEFAULT_ZOOM = 3

class Reveal extends Step
  explanation: detailsTemplate @

  map: null
  trail: null
  youAreHere: null

  chart: null

  elements:
    '.storm-name': 'stormNameContainer'
    '.map': 'mapContainer'
    '.graph': 'graphContainer'

  constructor: ->
    super
    window.reveal = @

    @map = new Leaflet.Map @mapContainer.get 0
    @map.setView [51.505, -0.09], DEFAULT_ZOOM
    @map.addLayer new Leaflet.TileLayer "http://{s}.tile.cloudmade.com/#{LEAFLET_API_KEY}/997/256/{z}/{x}/{y}.png"

    @trail = new Leaflet.Polyline []
    @trail.setStyle color: 'orange'
    @youAreHere = new Leaflet.CircleMarker [0, 0]
    @youAreHere.setRadius 10
    @youAreHere.setStyle fill: false, color: 'red'

    @map.addLayer @trail
    @map.addLayer @youAreHere

    @chart = new Highcharts.Chart
      chart:
        type: 'spline'
        renderTo: @graphContainer.get 0

      title:
        text: ''

      # xAxis:
      #   labels:
      #     rotation: -45
      series: [
        {name: 'Wind'}
        {name: 'Wind range', type: 'errorbar'}
        {name: 'Pressure'}
        {name: 'Pressure range', type: 'errorbar'}
      ]

      tooltip:
        shared: true

    $(window).on 'hashchange', =>
      # @map.invalidateSize()
      # @chart.setSize @graphContainer.width(), @graphContainer.height()

  enter: ->
    super
    @map.invalidateSize()
    @chart.setSize @graphContainer.width(), @graphContainer.height()

    @classifier.classification.send()
    console?.log 'Sent classification', JSON.stringify @classifier.classification

    getStorm = Api.current.get "https://dev.zooniverse.org/projects/cyclone_center/groups/#{@classifier.classification.subject.group_id}"
    getStorm.then (storm) =>
      @stormNameContainer.html storm.name

      categories = []

      lastLat = null
      lastLng = null

      for {time, lat, lng, wind, pressure} in storm.metadata.stats
        # Ignore any crazy numbers.
        lat = lastLat if lastLat and Math.abs(lastLat - lat) > 20
        lng = lastLng if lastLng and Math.abs(lastLng - lng) > 20

        lng += 360 if lng < 0 # 0 through 360 instead of -180 through +180

        [lastLat, lastLng] = [lat, lng]

        @trail.addLatLng [lat, lng]

        @chart.series[0].addPoint wind.wmo, false
        @chart.series[1].addPoint [wind.min, wind.max], false
        @chart.series[2].addPoint pressure.wmo, false
        @chart.series[3].addPoint [pressure.min, pressure.max], false
        categories.push time

      # @chart.axes[0].setCategories categories

      setTimeout =>
        @chart.setSize @graphContainer.width(), @graphContainer.height()
        @chart.redraw()

      coords = @classifier.classification.subject.coords
      coords[1] += 360 if coords[1] < 0
      @youAreHere.setLatLng coords
      @map.setView @classifier.classification.subject.coords, DEFAULT_ZOOM

  reset: ->
    super
    @trail.spliceLatLngs 0
    series.setData [] for series in @chart.series

module.exports = Reveal
