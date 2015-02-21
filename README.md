# D-Input

Derby input elements "emits" changes on every keystroke. This is great in some cases, but not so great for others.

This input elements will throttle changes until a timeout, enter key or a blur event is detected.

####Install
```sh
$ npm i d-input --save
```

####Usage
index.coffee
``` coffeescript
app.use require('d-input')
```
index.html
``` html5
<inputex type="text" name="test1" value="{{value}}" timeout="5000" />
<textareaex type="text" name="test2" value="{{value}}" />
```

###Notes
  - **textareaex** components must supply a value attribute. `<textareaex>{{value}}</textareaex>` are not supported.
  - default **timeout** is 2 seconds