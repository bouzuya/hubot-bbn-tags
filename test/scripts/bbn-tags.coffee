{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'bbn-tags', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot bbn tags'
          matches: ['@hubot bbn tags']
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

    describe 'invalid patterns', ->
      beforeEach ->
        @messages = [
          '@hubot hoge'
        ]

      it 'should not match', ->
        @messages.forEach (message) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          assert callback.callCount is 0

  describe 'robot.helpCommands()', ->
    it 'should be ["hubot bbn tags - display bbn (blog.bouzuya.net) tags"]', ->
      assert.deepEqual @robot.helpCommands(), [
        "hubot bbn tags - display bbn (blog.bouzuya.net) tags"
      ]
