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
        complete: () =>
          @isShown = false
      }
    )
    return @

  bind: () ->
    document.body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @show)
    document.body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @hide)
    document.body.addEventListener(ContentBuilder::event.PREVIOUS_ROW, @hide)
    document.body.addEventListener(ContentBuilder::event.NEXT_ROW, @hide)
    return @

module.exports = new FooterManager()
