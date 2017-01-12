const gulp = require('gulp'),
    browserify = require('browserify'),
    riotify = require('riotify'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer'),
    uglify = require('gulp-uglify');

// Gulp Task Definitions
// ---------------------------------------

// compile all .tag files and dependencies into single resource
gulp.task('compilejs', function () {
    return browserify({
        // Boolean for sourcemap support to be included with output JavaScript
        debug: true,

        // an array of all entry points where Browserify starts to look for required dependencies
        entries: ['./scripts/index.js'],

        // list of transforms that are supported,
        // riotify needs .tag file name extension to support tag compilation
        // compact: transforms </p> <p> to </p><p>
        // has NOTHING to do with minification
        "transform": [
            [ riotify, {
                "compact": true
            }],
        ]
    }).bundle()

    // pipe output from browserify into new .js file
    .pipe(source('app.min.js'))

    // convert streaming vinyl files to use buffers
    // required for uglify process
    .pipe(buffer())
    .pipe(uglify())

    // take the end result and place it to dist folder
    .pipe(gulp.dest('./dist/'));
});

// gulp watch task
gulp.task( 'watch', function () {
    gulp.watch('./tags/**/*.tag', [ 'compilejs' ] );
} );

// default gulp task
gulp.task('default', ['compilejs']);
