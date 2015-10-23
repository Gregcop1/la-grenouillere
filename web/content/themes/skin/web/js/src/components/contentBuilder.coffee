Velocity = require('velocity-animate')

module.exports = class ContentBuilder
  articlesLoaded: 0
  slice: []
  selector:
    siteContent: '#site-content'
    row: 'section-row'
    currentRow: 'current-row'
    currentArticle: 'cb-current-article'
    article: 'post-type-page'
    articleContent: 'article-content'
    cutByFooter: 'cut-by-footer'
    footer: '#footer'
    vc:
      almostVisible: 'wpb_animate_when_almost_visible'
      startAnimation: 'wpb_start_animation'
  transitionDuration:
    slide: 250
    fade: 250
  event:
    GOTO_ARTICLE: 'GOTO_ARTICLE'
    NEXT_ARTICLE: 'NEXT_ARTICLE'
    PREVIOUS_ARTICLE: 'PREVIOUS_ARTICLE'
    GOTO_ROW: 'GOTO_ROW'
    NEXT_ROW: 'NEXT_ROW'
    PREVIOUS_ROW: 'PREVIOUS_ROW'
    ARTICLES_LOADED: 'ARTICLES_LOADED'
    APP_IGNITION: 'APP_IGNITION'
    ARTICLES_DISPLAYED: 'ARTICLES_DISPLAYED'
    FOOTER_SHOW: 'FOOTER_SHOW'
    FOOTER_HIDE: 'FOOTER_HIDE'

  constructor: (menu, container) ->
    @viewport =
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 20 + 'px'
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) - 20 + 'px'
    @footer =
      width: parseInt(document.querySelector(@selector.footer).offsetWidth)
    @menu = document.querySelector(menu)
    @container = document.querySelector(container)
    @emptyContainer()
      .build()
      .load(0)
      .bind()

  emptyContainer: ->
    [].forEach.call(@container.children, (node) ->
      node.parentNode.removeChild(node)
    )
    return @

  build: ->
    [].forEach.call(@menu.children, @findLink)
    return @

  findLink: (parent) =>
    childrenLink = parent.querySelectorAll('.nav a')
    if(!childrenLink.length)
      childrenLink = parent.querySelectorAll('a')
    @slice.push([].slice.call(childrenLink))
    return @

  load: (index) ->
    if(@slice[index] != undefined)
      link = @slice[index].splice(0, 1)[0]
      @loadContent(index, link)
    return @

  loadContent: (index, link) ->
    XHRT = new XMLHttpRequest()
    XHRT.responseType = 'document'
    XHRT.onload = =>
      response = @setViewportSizeToContent(XHRT.response.querySelector('#content'))
      @buildArticle(index, response.innerHTML)
      document.body.dispatchEvent(new Event(@event.ARTICLES_LOADED))
    XHRT.open('GET', link.getAttribute('href'), true)
    XHRT.send()
    return @

  buildArticle: (index, content) ->
    @buildRow(index)
    content = @setViewportSizeToContent(content)
    @container.lastChild.innerHTML += content
    @container.lastChild.style.width = parseInt(@container.lastChild.style.width) + parseInt(@viewport.width) + 'px'

    if(@slice[index].length > 0)
      @load(index)
    else
      @load(++index)
    return @

  setViewportSizeToContent: (content) ->
    if(content.firstElementChild)
      content.firstElementChild.style.width = @viewport.width
      content.firstElementChild.style.height = @viewport.height
    return content

  resizeRowAndArticles: (e) =>
    @viewport =
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 20 + 'px'
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) - 20 + 'px'

    [].forEach.call(@container.children, (node) =>
      [].slice.call(node.children).forEach((child) =>
        child.style.width = @viewport.width
        child.style.height = @viewport.height
      )
    )

    return @

  buildRow: (index) ->
    if(@container.children.length <= index)
      row = document.createElement('div')
      row.classList.add(@selector.row)
      row.style.width = @viewport.width
      row.style.height = @viewport.height
      @container.appendChild( row )
    return @

  getCurrentRow: () =>
    currentRow = @container.querySelector('.' + @selector.currentRow)
    if(!currentRow)
      currentRow = @container.querySelector('.' + @selector.row)
    return currentRow

  goToNextRow: () =>
    @hideFooter()

    nextRow = @getNextRow()

    if(nextRow)
      firstArticle = nextRow.querySelector('.' + @selector.article)
      @goToArticle(firstArticle)
    return @

  getNextRow: () =>
    currentRow = @getCurrentRow()

    nextRow = currentRow.nextSibling
    while(nextRow && nextRow.nodeType != 1)
      nextRow = nextRow.nextSibling

    return nextRow

  goToPrevRow: () =>
    @hideFooter()

    previousRow = @getPrevRow()
    if(previousRow)
      firstArticle = previousRow.querySelector('.' + @selector.article)
      @goToArticle(firstArticle)
    return @

  getPrevRow: () =>
    currentRow = @getCurrentRow()

    previousRow = currentRow.previousSibling
    while(previousRow && previousRow.nodeType != 1)
      previousRow = previousRow.previousSibling

    return previousRow

  prepareSwitchOfRow: (cumulatedDelay) =>
    goTrough = false
    [].forEach.call(@container.querySelectorAll('.' + @selector.currentRow), (node) =>
      goTrough = true
      node.classList.remove(@selector.currentRow)

      # hide row
      Velocity(node, 'fadeOut', {duration: @transitionDuration.fade, delay: cumulatedDelay, easing: 'linear'})
    )

    if(goTrough)
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  goToRow: (row, cumulatedDelay) =>
    if(!row.classList.contains(@selector.currentRow))
      # reset row if necessary
      @hideFooter()

      cumulatedDelay += @prepareSwitchOfRow(cumulatedDelay)
      row.style.left = 0
      row.classList.add(@selector.currentRow)

      document.body.dispatchEvent(new Event(@event.GOTO_ROW))

      # show row
      Velocity(row, 'fadeIn', {duration: @transitionDuration.fade, delay: cumulatedDelay, easing: 'linear'})
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  prepareSwitchOfArticle: (cumulatedDelay) =>
    goTrough = false

    # disable visual composer animation
    @disableVcAnimation()

    [].forEach.call(@container.querySelectorAll('.' + @selector.currentArticle), (node) =>
      goTrough = true
      node.classList.remove(@selector.currentArticle)
      Velocity(node.querySelector('.' + @selector.articleContent),
        'fadeOut',
        {duration: @transitionDuration.fade, delay: cumulatedDelay, easing: 'linear'})
    )

    if(goTrough)
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  goToArticle: (article) =>
    if(!article.classList.contains(@selector.currentArticle))
      cumulatedDelay = 0
      cumulatedDelay = @prepareSwitchOfArticle(cumulatedDelay)
      row = article.closest('.' + @selector.row)
      cumulatedDelay = @goToRow(row, cumulatedDelay)

      article.classList.add(@selector.currentArticle)
      document.body.dispatchEvent(new Event(@event.GOTO_ARTICLE))
      # move slide
      newLeft = -(article.index() * parseInt(@viewport.width))
      Velocity(row,
        {left: newLeft + 'px'},
        {duration: @transitionDuration.slide, delay: cumulatedDelay, easing: 'linear'})
      cumulatedDelay += @transitionDuration.slide

      # show content
      Velocity(article.querySelector('.' + @selector.articleContent),
        'fadeIn',
        {
          duration: @transitionDuration.fade
          delay: cumulatedDelay
          easing: 'linear'
          begin: ((items) ->
            items.forEach((node) ->
              if(!node.style.height)
                node.style.height = node.children[0].offsetHeight + 'px'
            )
          )
          complete: (() =>
            # enable visual composer animation
            @enableVcAnimation(article)
          )
        }
      )
      cumulatedDelay += @transitionDuration.fade

    return cumulatedDelay

  getCurrentArticle: () =>
    currentArticle = @container.querySelector('.' + @selector.currentArticle)
    if(!currentArticle)
      currentArticle = @container.querySelector('.' + @selector.article)
    return currentArticle

  goToNextArticle: () =>
    nextArticle = @getNextArticle()

    if(nextArticle)
      @goToArticle(nextArticle)
    else
      @showFooter()
    return @

  getNextArticle: () =>
    currentArticle = @getCurrentArticle()

    nextArticle = currentArticle.nextSibling
    while(nextArticle && nextArticle.nodeType != 1)
      nextArticle = nextArticle.nextSibling

    return nextArticle

  goToPrevArticle: () =>
    currentArticle = @getCurrentArticle()

    if(currentArticle.classList.contains(@selector.cutByFooter))
      previousArticle = @hideFooter(currentArticle)
    else
      previousArticle = @getPreviousArticle()
    if(previousArticle)
      @goToArticle(previousArticle)

    return @

  getPreviousArticle: () =>
    currentArticle = @getCurrentArticle()

    previousArticle = currentArticle.previousSibling
    while(previousArticle && previousArticle.nodeType != 1)
      previousArticle = previousArticle.previousSibling

    return previousArticle

  showFooter: () =>
    article = @getCurrentArticle()
    article.classList.add(@selector.cutByFooter)
    row = article.closest('.' + @selector.row)

    document.body.dispatchEvent(new Event(@event.FOOTER_SHOW))
    newLeft = -((row.children.length - 1) * parseInt(@viewport.width)) - @footer.width
    Velocity(row,
      {left: newLeft + 'px'},
      {duration: @transitionDuration.slide, easing: 'linear'})
    Velocity(document.querySelector(@selector.siteContent),
      {left: 0, right: @footer.width},
      {duration: @transitionDuration.slide, easing: 'linear'})
    return @


  hideFooter: () =>
    currentArticle = @getCurrentArticle()
    if(currentArticle.classList.contains(@selector.cutByFooter))
      currentArticle.classList.remove(@selector.currentArticle)
      currentArticle.classList.remove(@selector.cutByFooter)
      row = currentArticle.closest('.' + @selector.row)

      document.body.dispatchEvent(new Event(@event.FOOTER_HIDE))
      newLeft = -((row.children.length - 1) * parseInt(@viewport.width))
      Velocity(row,
        {left: newLeft + 'px'},
        {duration: @transitionDuration.slide, easing: 'linear'})
      Velocity(document.querySelector(@selector.siteContent),
        {left: 0, right: 0},
        {duration: @transitionDuration.slide, easing: 'linear'})
    return currentArticle

  showFirstArticle: () =>
    if(@articlesLoaded == 10)
      @goToArticle(@container.querySelector('.' + @selector.article))
      document.body.removeEventListener(@event.ARTICLES_LOADED, @showFirstArticle)
      document.body.dispatchEvent(new Event(@event.ARTICLES_DISPLAYED))
    @articlesLoaded++
    return @

  enableVcAnimation: (article) =>
    [].forEach.call(article.querySelectorAll('.' + @selector.vc.almostVisible), (node) =>
      node.classList.add(@selector.vc.startAnimation)
    )

  disableVcAnimation: () =>
    [].forEach.call(@container.querySelectorAll('.' + @selector.vc.startAnimation), (node) =>
      node.classList.remove(@selector.vc.startAnimation)
    )

  bind: () ->
    window.addEventListener('resize', @resizeRowAndArticles)
    body = document.body
    body.addEventListener(@event.NEXT_ARTICLE, @goToNextArticle)
    body.addEventListener(@event.PREVIOUS_ARTICLE, @goToPrevArticle)
    body.addEventListener(@event.NEXT_ROW, @goToNextRow)
    body.addEventListener(@event.PREVIOUS_ROW, @goToPrevRow)
    body.addEventListener(@event.ARTICLES_LOADED, @showFirstArticle)
    body.addEventListener(window.mainMenuManager.event.OPEN_MENU, @hideFooter)
    return @
