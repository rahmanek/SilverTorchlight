
module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON "package.json"

		concat:
			dist:
				src: [
					"coffee/torch.coffee"
					"coffee/**/*.coffee"
				]
				dest: "tmp/torch.coffee"

		coffee:
			compile:
				files:
					"public/js/torch.js":"tmp/torch.coffee"

		jade:
			compile:
				options:
					pretty: true
				files:
					"public/index.html":"views/index.jade"


		sass:
			dist:
				files:
					'public/css/styles.css': 'scss/styles.scss'


		watch:
			files: ["coffee/**/*.coffee", "views/**/*.jade", "scss/**/*.scss"]
			tasks: "default"

		connect: 
			server:
				options:
					port: 8080,
					hostname: "*",
					keepalive:true
					base:"public"

	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-jade"
	grunt.loadNpmTasks "grunt-contrib-connect"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-sass"
	grunt.registerTask "default", ["concat","coffee","jade","sass","watch"]