Velocity = require('velocity-animate')
ContentBuilder = require('./ContentBuilder.coffee')
utils = require('./utils.coffee')

class MainMenuManager
  selector:
    logo: '#logo'
    siteContent: '#site-content'
    header: '#header'
    icon: '#menu-icon'
    button: '#header .nav-button'
    nav: '#nav-main'
    breadcrumb : '#breadcrumb'
  event:
    OPEN_MENU: 'OPEN_MENU'
    CLOSE_MENU: 'CLOSE_MENU'

  constructor: () ->
    @setVariables()
      .fixHeight()
      .build()
      .bind()
    return @

  setVariables: () =>
    @logo = document.querySelector(@selector.logo)
    @siteContent = document.querySelector(@selector.siteContent)
    @header = document.querySelector(@selector.header)
    @button = document.querySelector(@selector.button)
    @icon = document.querySelector(@selector.icon)
    @nav = document.querySelector(@selector.nav)
    @breadcrumb = document.querySelector(@selector.breadcrumb)
    @viewport =
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 20 + 'px'
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) + 'px'
    return @

  fixHeight: () =>
    @header.style.height = @viewport.height
    return @

  build: () =>
    Snap.load('/content/themes/skin/web/img/hamburger.svg', (f) =>
      g = f.select('g')
      @icon.innerHTML = g
    )

    return @

  toggleMenu: () =>
    if(@header.classList.contains('open'))
      @close()
    else
      @open()
    return @

  open: () =>
    @header.classList.add('open')
    @transformIconToClose()
    Velocity(@header, {marginLeft: 0}, {duration: ContentBuilder::transitionDuration.slide})
    Velocity(@siteContent, {left: '330px'}, {duration: ContentBuilder::transitionDuration.slide}, 'easeInOutQuart')
    Velocity(@breadcrumb, {left: '340px'}, {duration: ContentBuilder::transitionDuration.slide}, 'easeInOutQuart')
    jQuery('body').bind(@event.OPEN_MENU)
    return @

  close: (event) =>
    if(@header.classList.contains('open'))
      @header.classList.remove('open')
      @transformIconToBurger()
      Velocity(@header, {marginLeft: '-330px'}, {duration: ContentBuilder::transitionDuration.slide}, 'easeInOutQuart')
      if(!event || event.type != ContentBuilder::event.FOOTER_SHOW)
        Velocity(@siteContent, {left: 0}, {duration: ContentBuilder::transitionDuration.slide}, 'easeInOutQuart')
        Velocity(@breadcrumb, {left: 10}, {duration: ContentBuilder::transitionDuration.slide}, 'easeInOutQuart')
      jQuery('body').bind(@event.CLOSE_MENU)
    return @

  transformIconToBurger: () =>
    icon = Snap.select(@selector.icon)
    el1 = icon.select('path:nth-child(1)')
    if(el1)
      el1.animate({path: 'm 12.0916789,24.818994 40.8166421,0'}, 200, mina.backin)
      el2 = icon.select('path:nth-child(2)')
      el2.animate({opacity: 1}, 200, mina.backin)
      el3 = icon.select('path:nth-child(3)')
      el3.animate({path: 'm 12.0916788,56.95698 40.8166422,0'}, 200, mina.backin)

    return @

  transformIconToClose: () =>
    icon = Snap.select(@selector.icon)
    el1 = icon.select('path:nth-child(1)')
    if(el1)
      el1.animate({path: 'M 12.972944,56.95698 51.027056,24.818994'}, 200, mina.backin)
      el2 = icon.select('path:nth-child(2)')
      el2.animate({opacity: 0}, 200, mina.backin)
      el3 = icon.select('path:nth-child(3)')
      el3.animate({path: 'M 12.972944,24.818994 51.027056,56.95698'}, 200, mina.backin)

    return @

  manageLogoDisplay: () =>
    row = window.cb.getCurrentRow()
    if(row.index() + 1 == 1)
      @logo.classList.remove('shown')
    else
      @logo.classList.add('shown')
    return @

  clickOnMenuItem: (event) =>
    utils.linkToSlide(event)
    @close()

    return @

  bind: () =>
    jQuery(@button).bind('click', @toggleMenu)
    body = jQuery('body')
    body.bind(ContentBuilder::event.GOTO_ARTICLE, @manageLogoDisplay)
    body.bind(ContentBuilder::event.GOTO_ARTICLE, @close)
    body.bind(ContentBuilder::event.FOOTER_SHOW, @close)

    # bind links
    [].forEach.call(@nav.querySelectorAll('a'), (node) =>
      jQuery(node).bind('click', @clickOnMenuItem)
      return @
    )

    return @


module.exports = new MainMenuManager()
