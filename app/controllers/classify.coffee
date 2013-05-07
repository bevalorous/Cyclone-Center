Controller = require 'zooniverse/controllers/base-controller'
template = require '../views/classify'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
$ = require 'jqueryify'

StrongerStep = require './classify-steps/stronger'
MatchStep = require './classify-steps/match'

grabRandomSatellite = (subject) ->
  satellites = for satellite of subject.location
    continue if !!~satellite.indexOf 'yesterday'
    satellite

  satellites[Math.floor Math.random() * satellites.length]

class Classify extends Controller
  className: 'classify'
  template: template

  steps: null
  step: ''

  classification: null

  elements:
    '.subject .older': 'olderImg'
    '.subject .current': 'currentImg'
    '.step-controls': 'stepControls'

  constructor: ->
    super

    @el.addClass 'loading'

    User.on 'change', @onUserChange

    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

    @steps =
      stronger: (new StrongerStep classifier: @)
      match: (new MatchStep classifier: @)

  onUserChange: (e, user) ->
    Subject.next()

  onGettingNextSubject: =>
    @el.addClass 'loading'

  onSubjectSelect: (e, subject) =>
    @el.removeClass 'loading'

    @classification = new Classification {subject}

    satellite = grabRandomSatellite subject
    @currentImg.attr src: subject.location[satellite]

    olderLocation = subject.location["#{satellite}-yesterday"]
    if olderLocation?
      @olderImg.attr src: olderLocation
      @goToStep 'stronger'
    else
      @goToStep 'match'

  onNoMoreSubjects: =>
    @el.removeClass 'loading'

  goToStep: (step) ->
    @steps[@step]?.leave()
    @step = step

    @el.attr 'data-step', @step
    @steps[@step].enter()

module.exports = Classify
