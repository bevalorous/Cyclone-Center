Step = require './base-step'
template = require '../../views/classify-steps/feature'
translate = require 't7e'
$ = window.jQuery

class Feature extends Step
  property: 'banding_feature'

  template: template
  explanation: translate 'div', 'classify.details.feature'

  events:
    'click button[name="feature"]': 'onClickButton'

  elements:
    'button[name="feature"]': 'buttons'

  reset: ->
    super
    @buttons.removeClass 'active'

  onClickButton: (e) ->
    target = $(e.currentTarget)

    @buttons.removeClass 'active'
    target.addClass 'active'

    @classifier.classification.set @property, parseFloat target.val()

module.exports = Feature
