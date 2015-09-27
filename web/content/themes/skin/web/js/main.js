(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
$(function() {
  return $(window).ready(function() {

    /*
     * Handle pulldown
    $('.pulldown').pulldown()
    
     * Add backToTop anchor when half a screen  is scrolled
    $('body').append('<a id="backToTop" href="#">Back to top</a>')
    $('#backToTop').backToTop($(window).height()/2)
    
     * Refresh scroll offset of backToTop button appearance
    $(window).bind('resize', ->
      $('#backToTop').backToTop($(window).height()/2)
    )
     */
  });
});


},{}]},{},[1])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9ncnVudC1icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvZ2NvcGluL1NpdGVzL2xhLWdyZW5vdWlsbGVyZS93ZWIvY29udGVudC90aGVtZXMvc2tpbi93ZWIvanMvc3JjL21haW4uY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDY0EsQ0FBQSxDQUFHLFNBQUE7U0FDRCxDQUFBLENBQUUsTUFBRixDQUFTLENBQUMsS0FBVixDQUFpQixTQUFBOztBQUtmOzs7Ozs7Ozs7Ozs7O0VBTGUsQ0FBakI7QUFEQyxDQUFIIiwiZmlsZSI6ImdlbmVyYXRlZC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIiMgSGVscGVyc1xuI1xuIyBnZXRIYXNoID0gcmVxdWlyZSAnLi9jb21wb25lbnRzL2dldEhhc2guY29mZmVlJ1xuXG4jIGpRdWVyeSBoZWxwZXJzXG4jXG4jIHJlcXVpcmUoJy4vY29tcG9uZW50cy9qcXVlcnkuaG92ZXJTcmMuY29mZmVlJylcbiMgcmVxdWlyZSgnLi9jb21wb25lbnRzL2pxdWVyeS5wdWxsZG93bi5jb2ZmZWUnKVxuIyByZXF1aXJlKCcuL2NvbXBvbmVudHMvanF1ZXJ5LmZpeFRvVG9wLmNvZmZlZScpXG4jIHJlcXVpcmUoJy4vY29tcG9uZW50cy9qcXVlcnkuc21vb3RoQW5jaG9ycy5jb2ZmZWUnKVxuXG4jIFdlYnNpdGUgd2lkZSBzY3JpcHRzXG4jIEBhdXRob3IgRHVtbXkgVGVhbVxuI1xuJCggLT5cbiAgJCh3aW5kb3cpLnJlYWR5KCAtPlxuXG4gICAgIyBIYW5kbGUgc3JjIHVwZGF0ZSBvbiBob3ZlciBldmVudFxuICAgICMgJCgnLm5vLXRvdWNoIGltZy5ob3ZlcicpLmhvdmVyU3JjKClcblxuICAgICMjI1xuICAgICMgSGFuZGxlIHB1bGxkb3duXG4gICAgJCgnLnB1bGxkb3duJykucHVsbGRvd24oKVxuXG4gICAgIyBBZGQgYmFja1RvVG9wIGFuY2hvciB3aGVuIGhhbGYgYSBzY3JlZW4gIGlzIHNjcm9sbGVkXG4gICAgJCgnYm9keScpLmFwcGVuZCgnPGEgaWQ9XCJiYWNrVG9Ub3BcIiBocmVmPVwiI1wiPkJhY2sgdG8gdG9wPC9hPicpXG4gICAgJCgnI2JhY2tUb1RvcCcpLmJhY2tUb1RvcCgkKHdpbmRvdykuaGVpZ2h0KCkvMilcblxuICAgICMgUmVmcmVzaCBzY3JvbGwgb2Zmc2V0IG9mIGJhY2tUb1RvcCBidXR0b24gYXBwZWFyYW5jZVxuICAgICQod2luZG93KS5iaW5kKCdyZXNpemUnLCAtPlxuICAgICAgJCgnI2JhY2tUb1RvcCcpLmJhY2tUb1RvcCgkKHdpbmRvdykuaGVpZ2h0KCkvMilcbiAgICApXG4gICAgIyMjXG4gIClcbilcbiJdfQ==
