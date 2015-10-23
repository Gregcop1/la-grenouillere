ContentBuilder = require('./ContentBuilder.coffee')
Velocity = require('velocity-animate')
ProgressBar = require('progressbar.js')

class ArrowManager
  selector:
    breadcrumb: '#breadcrumb'
    progress: '#bc-progress'
    content: '#bc-content'
    grip: '#bc-grip'
    shown: 'shown'
    active: 'active'

  constructor: () ->
    @setVariables()
      .buildProgressBar()
      .bind()
    return @

  setVariables: () =>
    @breadcrumb = document.querySelector(@selector.breadcrumb)
    @progress = document.querySelector(@selector.progress)
    @content = document.querySelector(@selector.content)
    @grip = document.querySelector(@selector.grip)

    @progress = new ProgressBar.Line(@selector.progress)
    @progress.set(0)

    return @

  buildProgressBar: () =>
    return @

  prepareContent: () =>
    @hide()

    setTimeout((=>
      @buildContent()
        .show()
        .setActiveContent()
    ), ContentBuilder::transitionDuration.fade * 2 )

    return @

  buildContent: () =>
    currentRow = window.cb.getCurrentRow()
    @content.innerHTML = ''

    [].forEach.call(currentRow.querySelectorAll('h2'), (node) =>
      @content.innerHTML += '<li> \
        <a href="#" onclick="window.breadCrumbManager.clickOnItem(this)">' + node.innerText + '</a> \
      </li>'
    )

    # manage class
    [0, 1, 2, 3, 4, 5].forEach((index) =>
      @breadcrumb.classList.remove('col-' + index)
    )
    @breadcrumb.classList.add('col-' + @content.children.length)

    return @

  clickOnItem: (el) ->
    target = el.closest('li')
    row = window.cb.getCurrentRow()
    nextArticle = row.querySelector(':nth-child(' + (target.index() + 1) + ')')
    if(nextArticle)
      window.cb.goToArticle(nextArticle)

    return @

  setActiveContent: () =>
    currentArticle = window.cb.getCurrentArticle()
    if(currentArticle)
      currentArticleIndex = currentArticle.index()

    @setActiveProgress((() =>
      [].forEach.call(@content.children, (node, index) =>
        if(currentArticleIndex != -1 && index == currentArticleIndex)
          node.classList.add(@selector.active)
        else
          node.classList.remove(@selector.active)
      )
    ))

    return @

  setActiveProgress: (callback) =>
    currentArticle = window.cb.getCurrentArticle()
    if(currentArticle && @content.children.length)
      ratio = (currentArticle.index() / @content.children.length) + (1 / (2 * @content.children.length))
    else
      ratio = 0
    @progress.animate(ratio, {duration: ContentBuilder::transitionDuration.slide}, callback)
    Velocity(@grip,
      {left: (ratio * 100) + '%', opacity: Math.ceil(ratio)},
      {duration: ContentBuilder::transitionDuration.slide})

    return @

  show: () =>
    @breadcrumb.classList.add(@selector.shown)

    return @

  hide: () =>
    @breadcrumb.classList.remove(@selector.shown)

    return @

  openMenu: () =>
    Velocity(@breadcrumb, 'stop')
    Velocity(@breadcrumb, {left: '340px', right: '10px'}, {duration: ContentBuilder::transitionDuration.slide})
    return @

  closeMenu: () =>
    Velocity(@breadcrumb, {left: '10px'}, {duration: ContentBuilder::transitionDuration.slide})
    return @

  openFooterMenu: () =>
    Velocity(@breadcrumb, 'stop')
    Velocity(@breadcrumb,
      {left: '10px', right: parseInt(window.cb.footer.width) + 10 + 'px'},
      {duration: ContentBuilder::transitionDuration.slide})
    return @

  closeFooterMenu: () =>
    Velocity(@breadcrumb, {right: '10px'}, {duration: ContentBuilder::transitionDuration.slide})
    return @

  bind: ()  =>
    body = document.body
    body.addEventListener(ContentBuilder::event.GOTO_ROW, @prepareContent)
    body.addEventListener(ContentBuilder::event.GOTO_ARTICLE, @setActiveContent)
    body.addEventListener(window.mainMenuManager.event.OPEN_MENU, @openMenu)
    body.addEventListener(window.mainMenuManager.event.CLOSE_MENU, @closeMenu)
    body.addEventListener(ContentBuilder::event.FOOTER_SHOW, @openFooterMenu)
    body.addEventListener(ContentBuilder::event.FOOTER_HIDE, @closeFooterMenu)

    return @

module.exports = new ArrowManager()
