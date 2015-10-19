Velocity = require('velocity-animate')
ContentBuilder = require('./ContentBuilder.coffee')
utils = require('./utils.coffee')

class FooterManager
  selector:
    footer: '#footer'
    nav: '#nav-footer'
  isShown: false
  constructor: () ->
    @setVariables()
      .bind()
    return @

  setVariables: () =>
    @footer = document.querySelector(@selector.footer)
    @nav = document.querySelector(@selector.nav)

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
        easing: 'linear'
        complete: () =>
          @isShown = false
      }
    )
    return @

  clickOnMenuItem: (event) =>
    window.cb.hideFooter()
    utils.linkToSlide(event)
    return @

  bind: () ->
    body = document.body
    body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @show)
    body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @close)
#    body.addEventListener(ContentBuilder::event.PREVIOUS_ROW, @close)
#    body.addEventListener(ContentBuilder::event.NEXT_ROW, @close)

    # bind links
    [].forEach.call(@nav.querySelectorAll('a'), (node) =>
      node.addEventListener('click', @clickOnMenuItem)
      return @
    )

    return @

module.exports = new FooterManager()
