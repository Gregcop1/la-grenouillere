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
    @circle = new ProgressBar.Line('#preloader', {
      color: '#ebc390',
      strokeWidth: 8,
      duration: 7000
      trailColor: '#222',
      trailWidth: 8,
    })
    @circle.animate(1)

    return @

  hide: () =>
    Velocity(@preloader, 'fadeOut', {display: "none"}, {duration: 500})

    return @


  bind: () =>
    jQuery('body').bind('ARTICLES_DISPLAYED', @hide)

    return @


module.exports = new Preloader()
