Velocity = require('velocity-animate')
ContentBuilder = require('./ContentBuilder.coffee')
utils = require('./utils.coffee')

class FooterManager
  selector:
    footer: '#footer'
    nav: '#nav-footer'
    nextRow: '#next-row'
    nextRowTitle: '.title'
  isShown: false
  constructor: () ->
    @setVariables()
      .bind()
    return @

  setVariables: () =>
    @footer = document.querySelector(@selector.footer)
    @nav = document.querySelector(@selector.nav)
    @nextRow = document.querySelector(@selector.nextRow)

    return @

  prepareNextRow: () =>
    nextRow = window.cb.getNextRow()
    @nextRow.querySelector(@selector.nextRowTitle).innerHTML = ''

    if(nextRow)
      title = nextRow.querySelector('h3')
      if(title)
        @nextRow.querySelector(@selector.nextRowTitle).innerHTML = title.innerHTML
      Velocity(@nextRow, 'fadeIn', {duration: ContentBuilder::transitionDuration.fade})
    else
      Velocity(@nextRow, 'fadeOut', {duration: ContentBuilder::transitionDuration.fade})

    return @

  show: () =>
    @isShown = true
    Velocity(@footer, 'stop')
    Velocity(@footer, 'fadeIn', {
      duration: 0,
      queue: false
    })
    return @

  close: () =>
    Velocity(@footer,
      'fadeOut',
      {
        duration: if @isShown then ContentBuilder::transitionDuration.fade else 0
        delay: ContentBuilder::transitionDuration.fade * 2
        easing: 'easeInOutQuart'
        complete: () =>
          @isShown = false
      }
    )
    return @

  clickOnNextRow: (event) =>
    document.body.dispatchEvent(new Event(ContentBuilder::event.NEXT_ROW))
    return @

  clickOnMenuItem: (event) =>
    window.cb.hideFooter()
    utils.linkToSlide(event)
    return @

  bind: () ->
    body = document.body
    body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @show)
    body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @close)
    body.addEventListener(ContentBuilder::event.GOTO_ROW, @prepareNextRow)
    @nextRow.addEventListener('click', @clickOnNextRow)

    # bind links
    [].forEach.call(@nav.querySelectorAll('a'), (node) =>
      node.addEventListener('click', @clickOnMenuItem)
      return @
    )

    return @

module.exports = new FooterManager()
