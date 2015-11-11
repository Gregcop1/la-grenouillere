ProgressBar = require('progressbar.js')
Velocity = require('velocity-animate')

class Preloader
  constructor: () ->
    @build()
      .progressBar()
      .bind()

    return @

  build: () =>
    @preloader = document.querySelector('#preloader')
    return @

  progressBar: () =>
    @circle = new ProgressBar.Circle('#preloader', {
      color: '#ebc390',
      strokeWidth: 4,
      duration: 7000
    })
    @circle.animate(1)

    return @

  hide: () =>
    Velocity(@preloader, 'fadeOut', {duration: 500})

    return @


  bind: () =>
    jQuery('body').bind('ARTICLES_DISPLAYED', @hide)

    return @


module.exports = new Preloader()
