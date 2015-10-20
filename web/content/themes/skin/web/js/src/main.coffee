# Helpers
#
# getHash = require './components/getHash.coffee'


# Website wide scripts
# @author Dummy Team
#
window.addEventListener('load', ->
  # Content builder
  if(!document.body.classList.contains('home'))
    window.mainMenuManager = require('./components/MainMenuManager.coffee')
    window.keyboardListener = require('./components/keyboardListener.coffee')
    window.footerManager = require('./components/footerManager.coffee')

    ContentBuilder = require('./components/ContentBuilder.coffee')
    window.cb = new ContentBuilder('#nav-main > ul', '#content')
    window.arrowManager = require('./components/ArrowManager.coffee')
)
