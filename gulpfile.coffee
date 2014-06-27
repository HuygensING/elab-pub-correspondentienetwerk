gulp = require 'gulp'
gutil = require 'gulp-util'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
stylus = require 'gulp-stylus'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
connectRewrite = require './connect-rewrite'
cache = require 'gulp-cached'
plumber = require 'gulp-plumber'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
rsync = require("rsyncwrapper").rsync

compiledDir = './compiled'
distDir = './dist'
paths =
	coffee: [
		'./src/coffee/**/*.coffee'
		'./node_modules/elaborate-modules/modules/**/*.coffee'
		'./node_modules/hilib/src/**/*.coffee'
		'./node_modules/huygens-faceted-search/src/coffee/**/*.coffee'
	]
	jade: [
		'./src/index.jade'
	]
	stylus: [
		'./node_modules/hilib/src/views/**/*.styl'
		'./node_modules/huygens-faceted-search/src/stylus/**/*.styl'
		'./node_modules/elaborate-modules/modules/**/*.styl'
		'./src/stylus/**/*.styl'
	]

gulp.task 'connect', connect.server
	root: compiledDir,
	port: 9000,
	livereload: true
	middleware: connectRewrite

gulp.task 'connect-dist', connect.server
	root: distDir,
	port: 9002,
	middleware: connectRewrite

gulp.task 'jade', ->
	gulp.src(paths.jade)
		.pipe(plumber())
		.pipe(jade())
		.pipe(gulp.dest(compiledDir))
		.pipe(connect.reload())

gulp.task 'browserify', ->
	gulp.src('./src/coffee/main.coffee', read: false)
		.pipe(plumber())
		.pipe(cache('browserify'))
		.pipe(browserify(
			transform: ['coffeeify', 'jadeify']
			extensions: ['.coffee', '.jade']
		))
		.pipe(rename(extname:'.js'))
		.pipe(gulp.dest(compiledDir+'/js'))
		.pipe(connect.reload())

gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe(plumber())
		.pipe(stylus(
			use: ['nib']
		))
		.pipe(concat('main.css'))
		.pipe(gulp.dest(compiledDir+'/css'))
		.pipe(connect.reload())

gulp.task 'uglify', ->
	gulp.src(compiledDir+'/js/main.js')
		.pipe(uglify())
		.pipe(gulp.dest(distDir+'/js'))

gulp.task 'minify-css', ->
	gulp.src(compiledDir+'/css/main.css')
		.pipe(minifyCss())
		.pipe(gulp.dest(distDir+'/css'))

# gulp.task 'deploy', (done) ->
# 	rsync
# 		src: './dist'
# 		dest: 'gijsjb@hi7.huygens.knaw.nl:/data/htdocs/cdn/elaborate/publication/collection/development'
# 		recursive: true
# 		syncDest: true
# 		exclude: ['data', 'index.html']
# 		compareMode: "checksum"
# 	,
# 		(error,stdout,stderr,cmd) -> 
# 			gutil.log error
# 			gutil.log stdout
# 			gutil.log stderr
# 			done()

gulp.task 'clean-compiled', -> gulp.src(compiledDir+'/*').pipe(clean())
gulp.task 'clean-dist', -> gulp.src(distDir+'/*').pipe(clean())

gulp.task 'copy-static-compiled', -> gulp.src('./static/**/*').pipe(gulp.dest(compiledDir))
gulp.task 'copy-static-dist', -> gulp.src('./static/**/*').pipe(gulp.dest(distDir))

gulp.task 'copy-images-compiled', ['copy-static-compiled'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(compiledDir+'/images/hilib'))
gulp.task 'copy-images-dist', ['copy-static-dist'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(distDir+'/images/hilib'))

gulp.task 'copy-index', -> gulp.src(compiledDir+'/index.html').pipe(gulp.dest(distDir))

gulp.task 'compile', ['clean-compiled'], ->
	gulp.start 'copy-images-compiled'
	gulp.start 'browserify'
	gulp.start 'jade'
	gulp.start 'stylus'

gulp.task 'build', ['clean-dist'], ->
	gulp.start 'copy-images-dist'
	gulp.start 'copy-index'
	gulp.start 'uglify'
	gulp.start 'minify-css'
	
gulp.task 'watch', ->
	gulp.watch [paths.jade], ['jade']
	gulp.watch [paths.stylus], ['stylus']

gulp.task 'watchify', ->
	bundler = watchify
		entries: './src/coffee/main.coffee'
		extensions: ['.coffee', '.jade']

	bundler.transform('coffeeify')
	bundler.transform('jadeify')

	rebundle = ->
		bundler.bundle()
			.pipe(source('main.js'))
			.pipe(gulp.dest(compiledDir+'/js'))
			.pipe(connect.reload())

	bundler.on('update', rebundle)

	rebundle()

gulp.task 'default', ['stylus', 'connect', 'watch', 'watchify']