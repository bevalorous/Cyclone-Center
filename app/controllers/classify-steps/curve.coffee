Step = require './base-step'
template = require '../../views/classify-steps/curve'
$ = require 'jqueryify'

class Curve extends Step
  property: 'curve'

  template: template

  events:
    'click button[name="curve"]': 'onClickButton'

  elements:
    'button[name="curve"]': 'buttons'

  onClickButton: (e) ->
    target = $(e.currentTarget)

    @buttons.removeClass 'active'
    target.addClass 'active'

    @classifier.classification.set @property, target.val()

module.exports = Curve