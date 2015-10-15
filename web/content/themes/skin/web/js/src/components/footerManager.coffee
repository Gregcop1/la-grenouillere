Velocity = require('velocity-animate')
ContentBuilder = require('./ContentBuilder.coffee')

class FooterManager
  selector:
    footer: '#footer'
  isShown: false
  constructor: () ->
    @bind()
    return @

  show: () =>
    @isShown = true
    footer = document.querySelector(@selector.footer)
    Velocity(footer, 'stop')
    Velocity(footer, 'fadeIn', {
      duration: 0,
      queue: false
    })
    return @

  hide: () =>
    Velocity(document.querySelector(@selector.footer),
      'fadeOut',
      {
        duration: if @isShown then ContentBuilder::transitionDuration.fade else 0
        delay: ContentBuilder::transitionDuration.fade
        easing: 'linear'
        complete: () =>
          @isShown = false
      }
    )
    return @

  bind: () ->
    body = document.body
    body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @show)
    body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @hide)
    body.addEventListener(ContentBuilder::event.PREVIOUS_ROW, @hide)
    body.addEventListener(ContentBuilder::event.NEXT_ROW, @hide)
    return @

module.exports = new FooterManager()
