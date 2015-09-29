module.exports = class ContentBuilder
  slice: []

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
      @buildSlide(index, response.innerHTML)
    XHRT.open('GET', link.getAttribute('href'), true)
    XHRT.send()
    return @

  buildSlide: (index, content) ->
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
      row.classList.add('section-row')
      row.style.width = @viewport.width
      row.style.height = @viewport.height
      @container.appendChild( row )
    return @

  bind: () ->
    window.addEventListener('resize', @resizeRowAndArticles)
    return @