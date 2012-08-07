require 'lib/setup'

Spine = require('spine')
Manager = require('spine/lib/manager')
Route = require('spine/lib/route')
Classifier = require('controllers/classifier')
Profile = require('controllers/profile')

class App extends Manager.Stack
  controllers:
    # Using anonymous classes since we only need them for this stack.
    home: class extends Spine.Controller then el: '#home'
    classify: class extends Spine.Controller then el: '#classify'
    profile: class extends Profile then el: '#profile'

  default: 'home'

  routes:
    '/': 'home'
    '/home': 'home'
    '/classify': 'classify'

  constructor: ->
    super

    window.classifier = new Classifier el: '#classify .classifier'

    Route.setup()

module.exports = App
