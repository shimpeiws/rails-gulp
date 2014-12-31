gulp = require 'gulp'
coffee = require 'gulp-coffee'
sass = require 'gulp-ruby-sass'
plumber = require 'gulp-plumber'
bower = require 'main-bower-files'
browserify = require 'browserify'
rename = require 'gulp-rename'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
debowerify = require 'debowerify'

appPath = './itemlist-react/'

appAssetPath = 'app/assets/'
vendorAssetPath = 'vendor/assets/'

files =
  appCoffee: appPath + appAssetPath + 'javascripts/src/**/*.coffee'
  appCoffeeLib: appPath + appAssetPath + 'javascripts/lib/**/*.coffee'
  appSass: appPath + appAssetPath + 'stylesheets/src/**/*.scss'
  appSassLib: appPath + appAssetPath + 'stylesheets/lib/**/*.scss'

dest =
  js: appPath + appAssetPath + 'javascripts/src'
  jsLib: appPath + appAssetPath + 'javascripts/lib/'
  css: appPath + appAssetPath + 'stylesheets/src'
  cssLib: appPath + appAssetPath + 'stylesheets/lib'
  vendorJsLib: appPath + vendorAssetPath + 'javascripts/'

# 通常のcoffeeコンパイル
gulp.task 'coffee', ->
  gulp.src files.appCoffee
    .pipe plumber()
    .pipe coffee
      bare: true
    .pipe gulp.dest dest.js

# libはbrowserifyでコンパイル
gulp.task 'browserify' , ->
  browserify
    entries: [appPath + appAssetPath + 'javascripts/lib/main.coffee']
    extensions: ['.coffee']
  .bundle()
  .pipe source 'app.js'
  .pipe gulp.dest dest.jsLib

# 通常のsassコンパイル
gulp.task 'sass', ->
  gulp.src files.appSass
    .pipe plumber()
    .pipe sass
      style: 'expanded'
    .pipe gulp.dest dest.css

# lib甩のsassコンパイル
gulp.task 'libSass', ->
  gulp.src files.appSassLib
    .pipe plumber()
    .pipe sass
      style: 'expanded'
    .pipe gulp.dest dest.cssLib
    
gulp.task 'bower', ->
  gulp.src bower(), base: 'bower_components', bowerJson: 'bower.json'
    .pipe gulp.dest dest.vendorJsLib
 
gulp.task 'watch', ['build'], ->
  gulp.watch [files.appCoffee, files.appSass], ['coffee', 'sass']

gulp.task 'build', ['coffee', 'sass']

# gulp
gulp.task 'default', ->
  gulp.run ['bower', 'browserify', 'libSass', 'coffee', 'sass']