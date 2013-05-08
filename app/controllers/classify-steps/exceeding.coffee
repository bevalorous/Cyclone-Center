Step = require './base-step'
template = require '../../views/classify-steps/exceeding'
$ = require 'jqueryify'

class Exceeding extends Step
  property: 'exceeding'
  template: template

  hasDrawing: true
  center: null
  line: null

  events:
    'mousemove .subject': 'onMouseMove'
    'click button[name="exceeding"]': 'onClickExceeding'

  elements:
    'button[name="exceeding"]': 'buttons'

  constructor: ->
    super

    @center = @svg.create 'circle', r: 5, fill: 'black', 'stroke-width': 0

    @line = @svg.create 'path', d: '''
      M -40 -2
      L -10 -2
      L -10 2
      L -40 2
      Z
    ''', fill: 'transparent', stroke: 'black', 'stroke-width': 2

  enter: ->
    super

    center = @classifier.classification.get 'center'
    center ?= x: 160, y: 160

    @center.attr 'cx', center.x
    @center.attr 'cy', center.y

  onMouseMove: (e) ->
    center = @classifier.classification.get 'center'
    center ?= x: 160, y: 160

    subjectOffset = @classifier.currentImg.offset()
    x = e.pageX - subjectOffset.left
    y = e.pageY - subjectOffset.top

    deltaX = center.x - x
    deltaY = center.y - y
    angle = Math.atan2(deltaY, deltaX) * 180 / Math.PI

    @line.attr 'transform', "translate(#{x} #{y}) rotate(#{angle})"

  onClickExceeding: (e) ->
    target = $(e.target)

    @buttons.removeClass 'active'
    target.addClass 'active'

    @classifier.classification.set @property, target.val()

module.exports = Exceeding