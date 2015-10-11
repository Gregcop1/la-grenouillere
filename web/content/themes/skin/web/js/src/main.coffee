# Helpers
#
# getHash = require './components/getHash.coffee'


# Website wide scripts
# @author Dummy Team
#
window.addEventListener('load', ->
  # Content builder
  if(!document.body.classList.contains('home'))
    ContentBuilder = require('./components/contentBuilder.coffee')
    window.cb = new ContentBuilder('#nav-main > ul', '#content')

    window.keyboardListener = require('./components/keyboardListener.coffee')
)
