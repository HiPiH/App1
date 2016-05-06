var gulp = require('gulp');
var changed = require('gulp-changed');
var coffee = require('gulp-coffee');
var resolveDependencies = require('gulp-resolve-dependencies');
var coffeeLint = require('gulp-coffeelint');
var rm = require('gulp-rm');
var eco = require('gulp-eco');
var concat = require('gulp-concat');
var less = require('gulp-less');
var myth = require('gulp-myth');
var csso = require('gulp-csso');
var htmlreplace = require('gulp-html-replace');
var imageMin = require('gulp-imagemin');
var rename = require('gulp-rename');
var zip = require('gulp-zip');

var version = (function(){
    return (Math.random()*10000).toFixed(0)
})();

var paths = {
    temp: './temp/',
    vendors: '../client/vendors/',
    styles: ['../client/templates/main.less'],
    tempJS: ['./temp/**/*.js'],
    stylesWatch: ['../client/templates/**/*.less'],
    scriptsCoffee: ['../client/coffee/**/*.coffee'],
    scriptsVendors: [
        '../client/vendors/jquery.js',
        '../client/vendors/json2.js',
        '../client/vendors/jq.mobile.events.js',
        '../client/vendors/localization/CLDRPluralRuleParser/*.js',
        '../client/vendors/localization/jquery.i18n.js',
        '../client/vendors/localization/jquery.i18n.messages.js',
        '../client/vendors/localization/jquery.i18n.fallbacks.js',
        '../client/vendors/localization/jquery.i18n.parser.js',
        '../client/vendors/localization/jquery.i18n.emitter.js',
        '../client/vendors/localization/jquery.i18n.language.js',
        '../client/vendors/localization/languages/*.js',
        '../client/vendors/underscore.js',
        '../client/vendors/backbone.js',
        '../client/vendors/backbone.localStorage.js'
    ],
    scriptsTemplates: ['../client/templates/**/*.eco'],
    images: ['../client/images/**/*'],
    fonts: ['../client/fonts/*'],
    res: ['../client/res/**/**/**.*'],
    indexHtml:['../client/index.html']
};
var paths_phonegap = {
    styles: '../phonegap/Clarins/www/css/',
    scripts: '../phonegap/Clarins/www/js/',
    images: '../phonegap/Clarins/www/img/',
    fonts: '../phonegap/Clarins/www/fonts/',
    res: '../phonegap/Clarins/www/res/'
};
gulp.task('rpl',function(){
    gulp.src('../client/index.html')
        .pipe(htmlreplace({
            'js': ['js/vendors.'+version+'.js',
                   'js/templates.'+version+'.js',
                   'js/main.'+version+'.js'],
            'css':['css/main.'+version+'.css']
        }))
        .pipe(gulp.dest('../phonegap/Clarins/www/'));

});
gulp.task('lint', function () {
    coffeeLintParams = {
        indentation: {
            "value": 4,
            "level": "error"
        }
    };

    gulp.src(paths.scriptsCoffee)
        .pipe(coffeeLint(coffeeLintParams))
        .pipe(coffeeLint.reporter());
});

gulp.task('scripts', function () {
    gulp.src('../phonegap/Clarins/www/js/**.*', { read: false })
        .pipe(rm());

    gulp.src(paths.scriptsTemplates)
        .pipe(eco())
        .on('error', console.error)
        .pipe(concat('templates.'+version+'.js'))
        .pipe(gulp.dest(paths_phonegap.scripts));

    gulp.src(paths.scriptsCoffee)
        .pipe(changed(paths.vendors))
        .pipe(resolveDependencies({
            pattern: /#= require [\s-]*(.*?\.coffee)/g
        }))
        .pipe(concat('main.'+version+'.coffee'))
        .pipe(coffee())
        .on('error', console.error)
        .pipe(gulp.dest(paths_phonegap.scripts));

    gulp.src(paths.scriptsVendors)
        .pipe(concat('vendors.'+version+'.js'))
        .pipe(gulp.dest(paths_phonegap.scripts))
});

gulp.task('styles', function () {
    gulp.src('../phonegap/Clarins/www/css/**.*', { read: false })
        .pipe(rm());
    gulp.src(paths.styles)
        .pipe(changed(paths_phonegap.styles))
        .pipe(less())
        .on('error', console.error)
        .pipe(myth())
        .pipe(csso())
        .pipe(rename('main.'+version+'.css'))
        .pipe(gulp.dest(paths_phonegap.styles))
});

gulp.task('images', function () {
    gulp.src(paths.images)
        .pipe(changed(paths_phonegap.images))
        .pipe(imageMin({optimizationLevel: 5}))
        .pipe(gulp.dest(paths_phonegap.images))
});

gulp.task('fonts', function () {
    gulp.src(paths.fonts)
        .pipe(gulp.dest(paths_phonegap.fonts))
});

gulp.task('resources', function () {
    gulp.src(paths.res)
        .pipe(gulp.dest(paths_phonegap.res))
});

gulp.task('clear', function () {
//    gulp.src(paths.tempJS[0])
//        .pipe(rm())
});

gulp.task('watch', function () {
    gulp.watch(paths.scriptsCoffee, ['scripts','rpl']);
    gulp.watch(paths.scriptsVendors, ['scripts','rpl']);
    gulp.watch(paths.scriptsTemplates, ['scripts','rpl']);
    gulp.watch(paths.stylesWatch, ['styles','rpl']);
    gulp.watch(paths.images, ['images']);
    gulp.watch(paths.fonts, ['fonts']);
    gulp.watch(paths.indexHtml, ['rpl']);
    gulp.watch(paths.res, ['resources']);
});
gulp.task('pbuild',function(){
    gulp.src('../phonegap/zip/**/**/**.*', { read: false })
        .pipe(rm());
    gulp.src(['../phonegap/Clarins/www/**/**.*'])
        .pipe(gulp.dest('../phonegap/zip/'));
    gulp.src(['../phonegap/Clarins/config.xml'])
        .pipe(gulp.dest('../phonegap/zip/'));
    /*gulp.src('../phonegap/zip*//*')
        .pipe(zip('www.zip'))
        .pipe(gulp.dest('../phonegap/'));*/
    /*gulp.src('../phonegap/zip/', { read: false })
        .pipe(rm());*/
});


gulp.task('build', ['scripts', 'styles', 'images', 'fonts','resources','rpl','clear']);

gulp.task('default', ['scripts', 'styles', 'images', 'fonts','resources','rpl', 'watch', 'clear']);

gulp.task('zip',['pbuild']);

