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
    jQuery('body').dispatchEvent(ContentBuilder::event.NEXT_ROW)
    return @

  clickOnMenuItem: (event) =>
    window.cb.hideFooter()
    utils.linkToSlide(event)
    return @

  bind: () ->
    body = jQuery('body')
    body.bind(ContentBuilder::event.FOOTER_SHOW, @show)
    body.bind(ContentBuilder::event.FOOTER_HIDE, @close)
    body.bind(ContentBuilder::event.GOTO_ROW, @prepareNextRow)
    jQuery(@nextRow).bind('click', @clickOnNextRow)

    # bind links
    [].forEach.call(@nav.querySelectorAll('a'), (node) =>
      jQuery(node).bind('click', @clickOnMenuItem)
      return @
    )

    return @

module.exports = new FooterManager()
