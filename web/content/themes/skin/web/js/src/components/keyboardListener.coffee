class KeyBoardListener
  constructor: () ->
    @bind()

  keyDown: (event) =>
    switch event.keyCode
      when 38 then document.body.dispatchEvent(new Event('PREVIOUS_ROW')) #up
      when 40 then document.body.dispatchEvent(new Event('NEXT_ROW')) # down
      when 37 then document.body.dispatchEvent(new Event('PREVIOUS_ARTICLE')) # left
      when 39 then document.body.dispatchEvent(new Event('NEXT_ARTICLE')) # right
    return @

  bind: () ->
    document.body.addEventListener('keydown', @keyDown)
    return @

module.exports = new KeyBoardListener()