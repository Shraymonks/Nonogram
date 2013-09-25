{spawn, exec} = require 'child_process'

outputFile = 'js/nonogram.js'
srcDir = 'js'

output = (data) ->
	console.log data.toString().trim()

task 'build', 'Compile coffee-script files to nonogram.js', ->
	exec "coffee -j #{outputFile} -c #{srcDir}", (err, stdout, stderr) ->
		throw err if err

task 'watch', 'Watch and continually build coffee-script files', ->
	coffee = spawn 'coffee', ['-j', outputFile, '-wc', srcDir]

	coffee.stdout.on 'data', output
	coffee.stderr.on 'data', output
