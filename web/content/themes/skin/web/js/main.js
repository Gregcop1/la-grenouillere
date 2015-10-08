(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var ContentBuilder,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

module.exports = ContentBuilder = (function() {
  ContentBuilder.prototype.slice = [];

  function ContentBuilder(menu, container) {
    this.resizeRowAndArticles = bind(this.resizeRowAndArticles, this);
    this.findLink = bind(this.findLink, this);
    this.viewport = {
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) + 'px',
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) + 'px'
    };
    this.menu = document.querySelector(menu);
    this.container = document.querySelector(container);
    this.emptyContainer().build().load(0).bind();
  }

  ContentBuilder.prototype.emptyContainer = function() {
    [].forEach.call(this.container.children, function(node) {
      return node.parentNode.removeChild(node);
    });
    return this;
  };

  ContentBuilder.prototype.build = function() {
    [].forEach.call(this.menu.children, this.findLink);
    return this;
  };

  ContentBuilder.prototype.findLink = function(parent) {
    this.slice.push([].slice.call(parent.querySelectorAll('a')));
    return this;
  };

  ContentBuilder.prototype.load = function(index) {
    var link;
    if (this.slice[index] !== void 0) {
      link = this.slice[index].splice(0, 1)[0];
      this.loadContent(index, link);
    }
    return this;
  };

  ContentBuilder.prototype.loadContent = function(index, link) {
    var XHRT;
    XHRT = new XMLHttpRequest();
    XHRT.responseType = 'document';
    XHRT.onload = (function(_this) {
      return function() {
        var response;
        response = _this.setViewportSizeToContent(XHRT.response.querySelector('#content'));
        return _this.buildSlide(index, response.innerHTML);
      };
    })(this);
    XHRT.open('GET', link.getAttribute('href'), true);
    XHRT.send();
    return this;
  };

  ContentBuilder.prototype.buildSlide = function(index, content) {
    this.buildRow(index);
    content = this.setViewportSizeToContent(content);
    this.container.lastChild.innerHTML += content;
    this.container.lastChild.style.width = parseInt(this.container.lastChild.style.width) + parseInt(this.viewport.width) + 'px';
    if (this.slice[index].length > 0) {
      this.load(index);
    } else {
      this.load(++index);
    }
    return this;
  };

  ContentBuilder.prototype.setViewportSizeToContent = function(content) {
    if (content.firstElementChild) {
      content.firstElementChild.style.width = this.viewport.width;
      content.firstElementChild.style.height = this.viewport.height;
    }
    return content;
  };

  ContentBuilder.prototype.resizeRowAndArticles = function(e) {
    this.viewport = {
      width: Math.max(document.documentElement.clientWidth, window.innerWidth || 0) + 'px',
      height: Math.max(document.documentElement.clientHeight, window.innerHeight || 0) + 'px'
    };
    [].forEach.call(this.container.children, (function(_this) {
      return function(node) {
        node.style.width = node.children.length * parseInt(_this.viewport.width) + 'px';
        node.style.height = _this.viewport.height;
        return [].slice.call(node.children).forEach(function(child) {
          child.style.width = _this.viewport.width;
          return child.style.height = _this.viewport.height;
        });
      };
    })(this));
    return this;
  };

  ContentBuilder.prototype.buildRow = function(index) {
    var row;
    if (this.container.children.length <= index) {
      row = document.createElement('div');
      row.classList.add('section-row');
      row.style.width = this.viewport.width;
      row.style.height = this.viewport.height;
      this.container.appendChild(row);
    }
    return this;
  };

  ContentBuilder.prototype.bind = function() {
    window.addEventListener('resize', this.resizeRowAndArticles);
    return this;
  };

  return ContentBuilder;

})();


},{}],2:[function(require,module,exports){
var ContentBuilder;

ContentBuilder = require('./components/contentBuilder.coffee');

window.addEventListener('load', function() {
  return new ContentBuilder('#nav-main > ul', '#content');
});


},{"./components/contentBuilder.coffee":1}]},{},[2])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9ncnVudC1icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvZ2NvcGluL1NpdGVzL2xhLWdyZW5vdWlsbGVyZS93ZWIvY29udGVudC90aGVtZXMvc2tpbi93ZWIvanMvc3JjL2NvbXBvbmVudHMvY29udGVudEJ1aWxkZXIuY29mZmVlIiwiL1VzZXJzL2djb3Bpbi9TaXRlcy9sYS1ncmVub3VpbGxlcmUvd2ViL2NvbnRlbnQvdGhlbWVzL3NraW4vd2ViL2pzL3NyYy9tYWluLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0FBLElBQUEsY0FBQTtFQUFBOztBQUFBLE1BQU0sQ0FBQyxPQUFQLEdBQXVCOzJCQUNyQixLQUFBLEdBQU87O0VBRU0sd0JBQUMsSUFBRCxFQUFPLFNBQVA7OztJQUNYLElBQUMsQ0FBQSxRQUFELEdBQ0U7TUFBQSxLQUFBLEVBQU8sSUFBSSxDQUFDLEdBQUwsQ0FBUyxRQUFRLENBQUMsZUFBZSxDQUFDLFdBQWxDLEVBQStDLE1BQU0sQ0FBQyxVQUFQLElBQXFCLENBQXBFLENBQUEsR0FBeUUsSUFBaEY7TUFDQSxNQUFBLEVBQVEsSUFBSSxDQUFDLEdBQUwsQ0FBUyxRQUFRLENBQUMsZUFBZSxDQUFDLFlBQWxDLEVBQWdELE1BQU0sQ0FBQyxXQUFQLElBQXNCLENBQXRFLENBQUEsR0FBMkUsSUFEbkY7O0lBRUYsSUFBQyxDQUFBLElBQUQsR0FBUSxRQUFRLENBQUMsYUFBVCxDQUF1QixJQUF2QjtJQUNSLElBQUMsQ0FBQSxTQUFELEdBQWEsUUFBUSxDQUFDLGFBQVQsQ0FBdUIsU0FBdkI7SUFDYixJQUFDLENBQUEsY0FBRCxDQUFBLENBQ0UsQ0FBQyxLQURILENBQUEsQ0FFRSxDQUFDLElBRkgsQ0FFUSxDQUZSLENBR0UsQ0FBQyxJQUhILENBQUE7RUFOVzs7MkJBV2IsY0FBQSxHQUFnQixTQUFB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LENBQUMsUUFBUSxDQUFDLE1BQXBCLElBQThCLEtBQWpDO01BQ0UsR0FBQSxHQUFNLFFBQVEsQ0FBQyxhQUFULENBQXVCLEtBQXZCO01BQ04sR0FBRyxDQUFDLFNBQVMsQ0FBQyxHQUFkLENBQWtCLGFBQWxCO01BQ0EsR0FBRyxDQUFDLEtBQUssQ0FBQyxLQUFWLEdBQWtCLElBQUMsQ0FBQSxRQUFRLENBQUM7TUFDNUIsR0FBRyxDQUFDLEtBQUssQ0FBQyxNQUFWLEdBQW1CLElBQUMsQ0FBQSxRQUFRLENBQUM7TUFDN0IsSUFBQyxDQUFBLFNBQVMsQ0FBQyxXQUFYLENBQXdCLEdBQXhCLEVBTEY7O0FBTUEsV0FBTztFQVBDOzsyQkFTVixJQUFBLEdBQU0sU0FBQTtJQUNKLE1BQU0sQ0FBQyxnQkFBUCxDQUF3QixRQUF4QixFQUFrQyxJQUFDLENBQUEsb0JBQW5DO0FBQ0EsV0FBTztFQUZIOzs7Ozs7OztBQ3BGUixJQUFBOztBQUFBLGNBQUEsR0FBaUIsT0FBQSxDQUFRLG9DQUFSOztBQU1qQixNQUFNLENBQUMsZ0JBQVAsQ0FBd0IsTUFBeEIsRUFBZ0MsU0FBQTtTQUUxQixJQUFBLGNBQUEsQ0FBZSxnQkFBZixFQUFpQyxVQUFqQztBQUYwQixDQUFoQyIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJtb2R1bGUuZXhwb3J0cyA9IGNsYXNzIENvbnRlbnRCdWlsZGVyXG4gIHNsaWNlOiBbXVxuXG4gIGNvbnN0cnVjdG9yOiAobWVudSwgY29udGFpbmVyKSAtPlxuICAgIEB2aWV3cG9ydCA9XG4gICAgICB3aWR0aDogTWF0aC5tYXgoZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmNsaWVudFdpZHRoLCB3aW5kb3cuaW5uZXJXaWR0aCB8fCAwKSArICdweCdcbiAgICAgIGhlaWdodDogTWF0aC5tYXgoZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmNsaWVudEhlaWdodCwgd2luZG93LmlubmVySGVpZ2h0IHx8IDApICsgJ3B4J1xuICAgIEBtZW51ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcihtZW51KVxuICAgIEBjb250YWluZXIgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKGNvbnRhaW5lcilcbiAgICBAZW1wdHlDb250YWluZXIoKVxuICAgICAgLmJ1aWxkKClcbiAgICAgIC5sb2FkKDApXG4gICAgICAuYmluZCgpXG5cbiAgZW1wdHlDb250YWluZXI6IC0+XG4gICAgW10uZm9yRWFjaC5jYWxsKEBjb250YWluZXIuY2hpbGRyZW4sIChub2RlKSAtPlxuICAgICAgbm9kZS5wYXJlbnROb2RlLnJlbW92ZUNoaWxkKG5vZGUpXG4gICAgKVxuICAgIHJldHVybiBAXG5cbiAgYnVpbGQ6IC0+XG4gICAgW10uZm9yRWFjaC5jYWxsKEBtZW51LmNoaWxkcmVuLCBAZmluZExpbmspXG4gICAgcmV0dXJuIEBcblxuICBmaW5kTGluazogKHBhcmVudCkgPT5cbiAgICBAc2xpY2UucHVzaChbXS5zbGljZS5jYWxsKHBhcmVudC5xdWVyeVNlbGVjdG9yQWxsKCdhJykpKVxuICAgIHJldHVybiBAXG5cbiAgbG9hZDogKGluZGV4KSAtPlxuICAgIGlmKEBzbGljZVtpbmRleF0gIT0gdW5kZWZpbmVkKVxuICAgICAgbGluayA9IEBzbGljZVtpbmRleF0uc3BsaWNlKDAsIDEpWzBdXG4gICAgICBAbG9hZENvbnRlbnQoaW5kZXgsIGxpbmspXG4gICAgcmV0dXJuIEBcblxuICBsb2FkQ29udGVudDogKGluZGV4LCBsaW5rKSAtPlxuICAgIFhIUlQgPSBuZXcgWE1MSHR0cFJlcXVlc3QoKVxuICAgIFhIUlQucmVzcG9uc2VUeXBlID0gJ2RvY3VtZW50J1xuICAgIFhIUlQub25sb2FkID0gPT5cbiAgICAgIHJlc3BvbnNlID0gQHNldFZpZXdwb3J0U2l6ZVRvQ29udGVudChYSFJULnJlc3BvbnNlLnF1ZXJ5U2VsZWN0b3IoJyNjb250ZW50JykpXG4gICAgICBAYnVpbGRTbGlkZShpbmRleCwgcmVzcG9uc2UuaW5uZXJIVE1MKVxuICAgIFhIUlQub3BlbignR0VUJywgbGluay5nZXRBdHRyaWJ1dGUoJ2hyZWYnKSwgdHJ1ZSlcbiAgICBYSFJULnNlbmQoKVxuICAgIHJldHVybiBAXG5cbiAgYnVpbGRTbGlkZTogKGluZGV4LCBjb250ZW50KSAtPlxuICAgIEBidWlsZFJvdyhpbmRleClcbiAgICBjb250ZW50ID0gQHNldFZpZXdwb3J0U2l6ZVRvQ29udGVudChjb250ZW50KVxuICAgIEBjb250YWluZXIubGFzdENoaWxkLmlubmVySFRNTCArPSBjb250ZW50XG4gICAgQGNvbnRhaW5lci5sYXN0Q2hpbGQuc3R5bGUud2lkdGggPSBwYXJzZUludChAY29udGFpbmVyLmxhc3RDaGlsZC5zdHlsZS53aWR0aCkgKyBwYXJzZUludChAdmlld3BvcnQud2lkdGgpICsgJ3B4J1xuXG4gICAgaWYoQHNsaWNlW2luZGV4XS5sZW5ndGggPiAwKVxuICAgICAgQGxvYWQoaW5kZXgpXG4gICAgZWxzZVxuICAgICAgQGxvYWQoKytpbmRleClcbiAgICByZXR1cm4gQFxuXG4gIHNldFZpZXdwb3J0U2l6ZVRvQ29udGVudDogKGNvbnRlbnQpIC0+XG4gICAgaWYoY29udGVudC5maXJzdEVsZW1lbnRDaGlsZClcbiAgICAgIGNvbnRlbnQuZmlyc3RFbGVtZW50Q2hpbGQuc3R5bGUud2lkdGggPSBAdmlld3BvcnQud2lkdGhcbiAgICAgIGNvbnRlbnQuZmlyc3RFbGVtZW50Q2hpbGQuc3R5bGUuaGVpZ2h0ID0gQHZpZXdwb3J0LmhlaWdodFxuICAgIHJldHVybiBjb250ZW50XG5cbiAgcmVzaXplUm93QW5kQXJ0aWNsZXM6IChlKSA9PlxuICAgIEB2aWV3cG9ydCA9XG4gICAgICB3aWR0aDogTWF0aC5tYXgoZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmNsaWVudFdpZHRoLCB3aW5kb3cuaW5uZXJXaWR0aCB8fCAwKSArICdweCdcbiAgICAgIGhlaWdodDogTWF0aC5tYXgoZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmNsaWVudEhlaWdodCwgd2luZG93LmlubmVySGVpZ2h0IHx8IDApICsgJ3B4J1xuXG4gICAgW10uZm9yRWFjaC5jYWxsKEBjb250YWluZXIuY2hpbGRyZW4sIChub2RlKSA9PlxuICAgICAgbm9kZS5zdHlsZS53aWR0aCA9IG5vZGUuY2hpbGRyZW4ubGVuZ3RoICogcGFyc2VJbnQoQHZpZXdwb3J0LndpZHRoKSArICdweCdcbiAgICAgIG5vZGUuc3R5bGUuaGVpZ2h0ID0gQHZpZXdwb3J0LmhlaWdodFxuICAgICAgW10uc2xpY2UuY2FsbChub2RlLmNoaWxkcmVuKS5mb3JFYWNoKChjaGlsZCkgPT5cbiAgICAgICAgY2hpbGQuc3R5bGUud2lkdGggPSBAdmlld3BvcnQud2lkdGhcbiAgICAgICAgY2hpbGQuc3R5bGUuaGVpZ2h0ID0gQHZpZXdwb3J0LmhlaWdodFxuICAgICAgKVxuICAgIClcblxuICAgIHJldHVybiBAXG5cbiAgYnVpbGRSb3c6IChpbmRleCkgLT5cbiAgICBpZihAY29udGFpbmVyLmNoaWxkcmVuLmxlbmd0aCA8PSBpbmRleClcbiAgICAgIHJvdyA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ2RpdicpXG4gICAgICByb3cuY2xhc3NMaXN0LmFkZCgnc2VjdGlvbi1yb3cnKVxuICAgICAgcm93LnN0eWxlLndpZHRoID0gQHZpZXdwb3J0LndpZHRoXG4gICAgICByb3cuc3R5bGUuaGVpZ2h0ID0gQHZpZXdwb3J0LmhlaWdodFxuICAgICAgQGNvbnRhaW5lci5hcHBlbmRDaGlsZCggcm93IClcbiAgICByZXR1cm4gQFxuXG4gIGJpbmQ6ICgpIC0+XG4gICAgd2luZG93LmFkZEV2ZW50TGlzdGVuZXIoJ3Jlc2l6ZScsIEByZXNpemVSb3dBbmRBcnRpY2xlcylcbiAgICByZXR1cm4gQCIsIiMgSGVscGVyc1xuI1xuIyBnZXRIYXNoID0gcmVxdWlyZSAnLi9jb21wb25lbnRzL2dldEhhc2guY29mZmVlJ1xuQ29udGVudEJ1aWxkZXIgPSByZXF1aXJlKCcuL2NvbXBvbmVudHMvY29udGVudEJ1aWxkZXIuY29mZmVlJylcbiBcblxuIyBXZWJzaXRlIHdpZGUgc2NyaXB0c1xuIyBAYXV0aG9yIER1bW15IFRlYW1cbiNcbndpbmRvdy5hZGRFdmVudExpc3RlbmVyKCdsb2FkJywgLT5cbiAgIyBDb250ZW50IGJ1aWxkZXJcbiAgbmV3IENvbnRlbnRCdWlsZGVyKCcjbmF2LW1haW4gPiB1bCcsICcjY29udGVudCcpXG5cbilcbiJdfQ==
