originalLoad = require('module')._load
quibble = require('../../lib/quibble')

describe 'quibble', ->

  describe 'basic behavior', ->
    Given -> quibble('./../fixtures/a-function', -> "kek")
    Then -> require('./../fixtures/a-function')() == "kek"
    Then -> require('../fixtures/a-function')() == "kek"
    Then -> require('../../test/fixtures/a-function')() == "kek"
    Then -> require('./../fixtures/b-function')() == "b function"

  describe '.config', ->
    describe 'defaultFakeCreator', ->
      Given -> quibble.config(defaultFakeCreator: -> 'lol')
      When -> quibble('./lol')
      Then -> require('./../../test/lib/lol') == 'lol'

  describe '.reset', ->
    context 'ensure it clears its internal data structure of quibbles', ->
      Given -> quibble('./../fixtures/a-function', -> "ha")
      Given -> quibble.reset()
      When -> quibble('./some-other-thing')
      Then -> require('../fixtures/a-function')() == "the real function"

    context 'without a reset', ->
      Given -> quibble('./../fixtures/a-function', -> "ha")
      When -> quibble('./some-other-thing')
      Then -> require('../fixtures/a-function')() == "ha"


  afterEach -> quibble.reset()

describe 'quibble.reset', ->
  describe 'restores original require', ->
    Given -> # The above example group calls quibble.reset()
    Then -> require('module')._load == originalLoad