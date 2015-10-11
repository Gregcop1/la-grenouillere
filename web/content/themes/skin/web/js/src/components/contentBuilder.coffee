Velocity = require('velocity-animate')

HTMLElement.prototype.index = () ->
  self = @
  parent = self.parentNode
  i = 0
  while (self.previousElementSibling)
    i++
    self = self.previousElementSibling

  if(@ == parent.children[i])
    return i

  return -1

module.exports = class ContentBuilder
  slice: []
  classes:
    row: 'section-row'
    currentRow: 'current-row'
    currentArticle: 'current-article'
    article: 'post-type-page'
    articleContent: 'article-content'
  transitionDuration:
    slide: 250
    fade: 350

  constructor: (menu, container) ->
    @viewport =
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) + 'px'
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) + 'px'
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
    @slice.push([].slice.call(parent.querySelectorAll('a')))
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
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) + 'px'
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) + 'px'

    [].forEach.call(@container.children, (node) =>
      node.style.width = node.children.length * parseInt(@viewport.width) + 'px'
      node.style.height = @viewport.height
      [].slice.call(node.children).forEach((child) =>
        child.style.width = @viewport.width
        child.style.height = @viewport.height
      )
    )

    return @

  buildRow: (index) ->
    if(@container.children.length <= index)
      row = document.createElement('div')
      row.classList.add(@classes.row)
      row.style.width = @viewport.width
      row.style.height = @viewport.height
      @container.appendChild( row )
    return @

  getCurrentRow: () =>
    currentRow = @container.querySelector('.' + @classes.currentRow)
    if(!currentRow)
      currentRow = @container.querySelector('.' + @classes.row)
    return currentRow

  goToNextRow: () =>
    currentRow = @getCurrentRow()

    nextRow = currentRow.nextSibling
    while(nextRow && nextRow.nodeType != 1)
      nextRow = nextRow.nextSibling

    if(nextRow)
      firstArticle = nextRow.querySelector('.' + @classes.article)
      @goToArticle(firstArticle)
    return @

  goToPrevRow: () =>
    currentRow = @getCurrentRow()

    previousRow = currentRow.previousSibling
    while(previousRow && previousRow.nodeType != 1)
      previousRow = previousRow.previousSibling

    if(previousRow)
      firstArticle = previousRow.querySelector('.' + @classes.article)
      @goToArticle(firstArticle)
    return @

  prepareSwitchOfRow: (cumulatedDelay) =>
    goTrough = false
    [].forEach.call(@container.querySelectorAll('.' + @classes.currentRow), (node) =>
      goTrough = true
      node.classList.remove(@classes.currentRow)

      # hide row
      Velocity(node, 'fadeOut', {duration: @transitionDuration.fade, delay: cumulatedDelay})
    )

    if(goTrough)
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  goToRow: (row, cumulatedDelay) =>
    if(!row.classList.contains(@classes.currentRow))
      cumulatedDelay += @prepareSwitchOfRow(cumulatedDelay)
      row.style.marginLeft = 0
      row.classList.add(@classes.currentRow)

      # show row
      Velocity(row, 'fadeIn', {duration: @transitionDuration.fade, delay: cumulatedDelay})
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  prepareSwitchOfArticle: (cumulatedDelay) =>
    goTrough = false
    [].forEach.call(@container.querySelectorAll('.' + @classes.currentArticle), (node) =>
      goTrough = true
      node.classList.remove(@classes.currentArticle)
      Velocity(node.querySelector('.' + @classes.articleContent),
        'fadeOut',
        {duration: @transitionDuration.fade, delay: cumulatedDelay})
    )

    if(goTrough)
      return (cumulatedDelay + @transitionDuration.fade)

    return cumulatedDelay

  goToArticle: (article) =>
    if(!article.classList.contains(@classes.currentArticle))
      cumulatedDelay = 0
      cumulatedDelay = @prepareSwitchOfArticle(cumulatedDelay)
      row = article.closest('.' + @classes.row)
      cumulatedDelay = @goToRow(row, cumulatedDelay)

      article.classList.add(@classes.currentArticle)
      # move slide
      newLeft = -(article.index() * parseInt(@viewport.width))
      Velocity(row,
        {marginLeft: newLeft + 'px'},
        {duration: @transitionDuration.slide, delay: cumulatedDelay})
      cumulatedDelay += @transitionDuration.slide

      # show content
      Velocity(article.querySelector('.' + @classes.articleContent),
        'fadeIn',
        {duration: @transitionDuration.fade, delay: cumulatedDelay}
      )
      cumulatedDelay += @transitionDuration.fade

    return cumulatedDelay

  getCurrentArticle: () =>
    currentArticle = @container.querySelector('.' + @classes.currentArticle)
    if(!currentArticle)
      currentArticle = @container.querySelector('.' + @classes.article)
    return currentArticle

  goToNextArticle: () =>
    currentArticle = @getCurrentArticle()

    nextArticle = currentArticle.nextSibling
    while(nextArticle && nextArticle.nodeType != 1)
      nextArticle = nextArticle.nextSibling

    if(nextArticle)
      @goToArticle(nextArticle)
    return @

  goToPrevArticle: () =>
    currentArticle = @getCurrentArticle()

    previousArticle = currentArticle.previousSibling
    while(previousArticle && previousArticle.nodeType != 1)
      previousArticle = previousArticle.previousSibling

    if(previousArticle)
      @goToArticle(previousArticle)
    return @

  bind: () ->
    window.addEventListener('resize', @resizeRowAndArticles)
    document.body.addEventListener('NEXT_ARTICLE', @goToNextArticle)
    document.body.addEventListener('PREVIOUS_ARTICLE', @goToPrevArticle)
    document.body.addEventListener('NEXT_ROW', @goToNextRow)
    document.body.addEventListener('PREVIOUS_ROW', @goToPrevRow)

    return @