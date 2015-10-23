ContentBuilder = require('./ContentBuilder.coffee')
Hammer = require('hammerjs')
_ = require('lodash')

class MouseManager
  constructor: () ->
    @build()
      .bind()

    return @

  build: () =>
    @hm = new Hammer.Manager(document.body, {
      recognizers: [
        [Hammer.Pan, {direction: Hammer.DIRECTION_ALL}]
      ]
    })

    return @

  pan: (e) =>
    if(e)
      body = document.body

      switch(e.type)
        when 'panup' then window.cb.goToNextRow()
        when 'pandown' then window.cb.goToPrevRow()
        when 'panleft' then window.cb.goToNextArticle()
        when 'panright' then window.cb.goToPrevArticle()
    return @

  bind: () =>
    @hm.on('panup', _.debounce(@pan, 300, {}, true))
    @hm.on('pandown', _.debounce(@pan, 300, {}, true))
    @hm.on('panleft', _.debounce(@pan, 300, {}, true))
    @hm.on('panright', _.debounce(@pan, 300, {}, true))

    return @

module.exports = new MouseManager()
