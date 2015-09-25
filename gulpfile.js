var gulp = require('gulp');
var concat = require('gulp-concat');

gulp.task('default', function() {
	  // place code for your default task here
	  return gulp.src(['./docs/header.html', './docs/main.html', './docs/footer.html'])
	  		.pipe(concat('index.html'))
	  		.pipe(gulp.dest('./www/'));
});
