module.exports = class Base

    timeoutHandle = null

    create : (model, dom) ->
      component = @

      @model.setNull 'timeout', 2000 # default timeout

      val = @model.get "value" or @model.get "content"

      @model.set '_page.value', val

      @model.on 'all', 'value', (event, val, older, other...) ->
        # external changes
        clearTimeout timeoutHandle
        model.set '_page.value', val

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

      #console.log "OnChange"
      clearTimeout timeoutHandle
      timeoutHandle = setTimeout ->
        component.commit()
      ,  @model.get 'timeout'

    commit : ()->
      #console.log "Commit"
      clearTimeout timeoutHandle
      if @mInput.checkValidity()
        @model.set 'value',
          @model.get '_page.value'