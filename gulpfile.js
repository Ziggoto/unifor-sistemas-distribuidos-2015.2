var gulp = require('gulp');
var concat = require('gulp-concat');
var run = require('gulp-run');


gulp.task('default', function() {
	  // place code for your default task here
	  return run('./bin/parse_times.py').exec().pipe(gulp.src(['./docs/header.html', './docs/main.html', './docs/footer.html'])
	  		.pipe(concat('index.html'))
	  		.pipe(gulp.dest('./www/')));
});
