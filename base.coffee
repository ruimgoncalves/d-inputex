module.exports = class Base

  timeoutHandle = null

  create : (model, dom) ->
    component = @

    @model.setNull 'timeout', 2000 # default timeout
    @model.setNull 'commitError', false
    @model.setNull 'sending', false

    val = @model.get "value" or @model.get "content"

    @model.set 'innerValue', val

    @model.on 'all', 'value', (event, val, older, other...) ->
      # external changes
      clearTimeout timeoutHandle
      model.set 'innerValue', val

    # this is a form of event binding
    dom.on 'keyup', component.mInput, (e) ->
      if e.keyCode == 13
        #e.preventDefault()
        component.commit()

    dom.on 'input', component.mInput, (e) ->
      component.changed()

  destroy : () ->
    clearTimeout timeoutHandle

  # this is other form of event binding
  onBlur : (ev, el)->
    @commit()

  changed : (ev, el)->
    component = @

    clearTimeout timeoutHandle

    timeoutHandle = setTimeout ->
      component.commit()
    ,  @model.get 'timeout'

  commit : ()->
    component = @

    clearTimeout timeoutHandle

    if @mInput.checkValidity() and @model.get('value') != @model.get('innerValue')
      @model.set "sending", true
      @model.set 'value', @model.get('innerValue'), (err, val)->
        component.model.set "sending", false
        component.model.set "commitError", err?
        if err
          component.emit 'servererror', err
