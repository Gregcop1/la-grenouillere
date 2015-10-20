ContentBuilder = require('./ContentBuilder.coffee')
Velocity = require('velocity-animate')

class ArrowManager
  selector:
    prev: '#arrow-prev'
    next: '#arrow-next'
    preview: '.preview'
    hover: 'hover'

  constructor: () ->
    @setVariables()
      .bind()
    return @

  setVariables: () =>
    @prev = document.querySelector(@selector.prev)
    @next = document.querySelector(@selector.next)

    return @

  prepareArrow: () =>
    currentArticle = window.cb.getCurrentArticle()
    previousArticle = window.cb.getPreviousArticle()

    @preparePreviousArrowContent()
    @prepareNextArrowContent()

    if(previousArticle || currentArticle.classList.contains(ContentBuilder::selector.cutByFooter))
      style = window.getComputedStyle(@prev, false)
      if(style.opacity == '0')
        Velocity(@prev, 'fadeIn', {duration: ContentBuilder::transitionDuration.fade})
    else
      Velocity(@prev, 'fadeOut', {duration: ContentBuilder::transitionDuration.fade})

    if(!currentArticle.classList.contains(ContentBuilder::selector.cutByFooter))
      style = window.getComputedStyle(@next, false)
      if(style.opacity == '0')
        Velocity(@next, 'fadeIn', {duration: ContentBuilder::transitionDuration.fade})
    else
      Velocity(@next, 'fadeOut', {duration: ContentBuilder::transitionDuration.fade})

    return @

  preparePreviousArrowContent: () =>
    previousArticle = window.cb.getPreviousArticle()
    preview = @prev.querySelector(@selector.preview)
    preview.innerHTML = ''

    if(previousArticle)
      preview.innerHTML = @getPreviewContent(previousArticle)

    return @

  prepareNextArrowContent: () =>
    nextArticle = window.cb.getNextArticle()
    preview = @next.querySelector(@selector.preview)
    preview.innerHTML = ''

    if(nextArticle)
      preview.innerHTML = @getPreviewContent(nextArticle)

    return @

  getPreviewContent: (article) ->
    preview = ''
    if(article)
      style = window.getComputedStyle(article, false)
      bg = style.backgroundImage.slice(4, -1).replace(/"/g, '')
      preview += '<img src="' + bg + '" alt=""/>'

      title = article.querySelector('h2')
      if(title)
        preview += '<h3>' + title.innerHTML + '</h3>'

    return preview

  prepareArrowOnce: () =>
    @prepareArrow()
    document.body.removeEventListener(ContentBuilder::event.ARTICLES_LOADED, @prepareArrowOnce)

    return @

  hover: (event) =>
    target = event.target.closest('a')

    if(target && target.querySelector(@selector.preview).innerHTML != '')
      target.classList.add(@selector.hover)

    return @

  out: () =>
    @prev.classList.remove(@selector.hover)
    @next.classList.remove(@selector.hover)

    return @

  goToPrevArticle: () =>
    @out()
    setTimeout((->
      document.body.dispatchEvent(new Event(ContentBuilder::event.PREVIOUS_ARTICLE))
    ), 600)

    return @

  goToNextArticle: () =>
    @out()
    setTimeout((->
      document.body.dispatchEvent(new Event(ContentBuilder::event.NEXT_ARTICLE))
    ), 600)

    return @

  bind: ()  =>
    body = document.body
    body.addEventListener(ContentBuilder::event.GOTO_ARTICLE, @prepareArrow)
    body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @prepareArrow)
    body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @prepareArrow)
    body.addEventListener(ContentBuilder::event.ARTICLES_LOADED, @prepareArrowOnce)

    [@prev, @next].map(((item) =>
      item.addEventListener('mouseover', @hover)
      item.addEventListener('mouseout', @out)
    ))
    @prev.addEventListener('click', @goToPrevArticle)
    @next.addEventListener('click', @goToNextArticle)

    return @

module.exports = new ArrowManager()
