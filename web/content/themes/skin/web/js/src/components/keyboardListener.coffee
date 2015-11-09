ContentBuilder = require('./ContentBuilder.coffee')

class KeyBoardListener
  constructor: () ->
    @bind()

  keyDown: (event) =>
    switch event.keyCode
      when 38 then jQuery('body').trigger(ContentBuilder::event.PREVIOUS_ROW) #up
      when 40 then jQuery('body').trigger(ContentBuilder::event.NEXT_ROW) # down
      when 37 then jQuery('body').trigger(ContentBuilder::event.PREVIOUS_ARTICLE) # left
      when 39 then jQuery('body').trigger(ContentBuilder::event.NEXT_ARTICLE) # right
    return @

  bind: () ->
    document.body.addEventListener('keydown', @keyDown)
    return @

module.exports = new KeyBoardListener()
