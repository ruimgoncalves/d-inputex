# D-Input

Derby input elements "emits" changes on every keystroke. This is great in some cases, but not so great for others.

This input elements will throttle changes until a timeout, enter key or a blur event is detected.

A done event is emitted every time the server responds to the changes so here is a good place to put your validation code. Use the ```on-done="func()"``` attribute, func will receive the following parameters.
- element - the input element being referenced
- error - the error object
- op - the result from the server.

See the example below for details.

The input element has some built in classes.
- **onError** : is added when an error occurs.
- **sending** : when values are being sended to the server.

###Install
```sh
$ npm i d-input --save
```

###Usage

index.html
``` html5
<!-- Set timeout to 5 seconds -->
<inputex type="text" name="test1" value="{{value}}" timeout="5000" />
<!-- Use a callback when value changes -->
<textareaex type="text" name="test2" value="{{value}}" on-done="inputDone()" />
```


index.coffee
``` coffeescript
app.use require('d-input')

app.proto.inpuDone = (elm, err, op)->
  if err
    elm.setCustomValidity err.errors[0].message
  else
    elm.setCustomValidity ""
```

##Notes
  - **textareaex** components must supply a value attribute. `<textareaex>{{value}}</textareaex>` is not supported.
  - default **timeout** is 2 seconds
  - disable **timeout** by setting it to 0
