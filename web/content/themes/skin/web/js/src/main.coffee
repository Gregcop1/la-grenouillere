# Helpers
#
# getHash = require './components/getHash.coffee'


# Website wide scripts
# @author Dummy Team
#
window.addEventListener('load', ->
  window.preloader = require('./components/preloader.coffee')

  # Content builder
#  if(!document.body.classList.contains('home'))
  window.mainMenuManager = require('./components/MainMenuManager.coffee')
  window.keyboardListener = require('./components/keyboardListener.coffee')
  window.footerManager = require('./components/footerManager.coffee')

  ContentBuilder = require('./components/ContentBuilder.coffee')
  window.cb = new ContentBuilder('#nav-main > ul', '#content')
  window.arrowManager = require('./components/ArrowManager.coffee')
  window.breadCrumbManager = require('./components/breadCrumbManager.coffee')
  window.mouseManager = require('./components/mouseManager.coffee')
)
