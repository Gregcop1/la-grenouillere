# Helpers
#
# getHash = require './components/getHash.coffee'
ContentBuilder = require('./components/contentBuilder.coffee')


# Website wide scripts
# @author Dummy Team
#
window.addEventListener('load', ->
  # Content builder
  new ContentBuilder('#nav-main > ul', '#content')
)
