ContentBuilder = require('./ContentBuilder.coffee')

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

class Utils
  constructor: () ->
    return @

  getArticleFromMenuItem: (node) ->
    articleItem = node.closest('.menu-item')
    # check if it's a first or second level item
    if(articleItem.classList.contains('nav-item'))
      rowItem = articleItem
      articleItem = articleItem.querySelector('li')
    else
      rowItem = node.closest('.nav-item')

    content = document.querySelector('#content')
    rowIndex = rowItem.index() + 1
    if(articleItem)
      articleIndex = articleItem.index() + 1
    else
      articleIndex = 1
    row = content.querySelector('.' + window.cb.selector.row + ':nth-child(' + rowIndex + ')')
    article = row.querySelector('.' + window.cb.selector.article + ':nth-child(' + articleIndex + ')')

    return article

  linkToSlide: (event) =>
    event.preventDefault()
    node = event.target
    article = @getArticleFromMenuItem(node)

    window.cb.goToArticle(article)

    return @

module.exports = new Utils()
