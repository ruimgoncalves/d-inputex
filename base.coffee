module.exports = class Base

  constructor : ()->
    @timeoutHandle = null

  init : (model)->
    model.setNull 'timeout', 2000 # default timeout
    model.setNull 'commitError', false
    model.setNull 'sending', false

    val = model.get("value") or @model.get("content")
    model.set 'innerValue', val

  create : (model, dom) ->
    that = @

    model.on 'change', 'value', (val, older, pass) ->
      return if pass.internal
      clearTimeout that.timeoutHandle
      model.set 'innerValue', val

    # this is a form of event binding
    dom.on 'keyup', that.mInput, (e) ->
      if e.keyCode is 13
        that.commit()

    dom.on 'input', that.mInput, (e) ->
      that.changed()

  destroy : () ->
    that = @
    clearTimeout that.timeoutHandle

  # this is other form of event binding
  onBlur : (ev, el)->
    @commit()

  changed : (ev, el)->
    that = @

    clearTimeout that.timeoutHandle

    that.timeoutHandle = setTimeout ->
      that.commit()
    ,  @model.get 'timeout'

  commit : ()->
    that = @
    clearTimeout that.timeoutHandle

    isValid = @mInput.validity.customError or @mInput.checkValidity()

    if isValid and @model.get('value') != @model.get('innerValue')
      @model.set "sending", true
      @model.pass({inside : true}).set 'value', @model.get('innerValue'),
        (err, val)->
          that.model.set "sending", false
          that.model.set "commitError", err?
          that.emit 'done', that.mInput, err, val
