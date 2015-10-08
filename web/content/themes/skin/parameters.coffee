module.exports =
  sync:
    # Files which trigger a browser reload
    files: [
      'web/*.html'
      'web/css/*.css'
      'web/js/*.js'
      'web/img/**'
    ]
    # Start a basic file server
    server: false
    # Use an existing server (apache,node...)
    proxy: false # 'domain.local'
    # Open browser on server start
    open: false

  # Errors while linting prevent compilation
  lint:
    lock: false

  autoprefixer:
    browsers: 'last 3 version'

  # Source files
  js:
    source: 'web/js/src/'
    dest: 'web/js/'
  css:
    source  : 'web/css/src/'
    dest : 'web/css/'
    style: 'compact'
    precision: 20
