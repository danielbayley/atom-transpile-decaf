module.exports =
	package: require './package.json'
	#config: -> atom.config.get @package.name

	activate: ->
		flavor = atom.config.get "#{@package.name}.flavor"
		# TODO live reload menus onDidChange
		name: "transpile-#{flavor}"
		from:
			scopeName: 'source.coffee'
			fileTypes: ['coffee']
		to: scopeName: 'source.js'

		transpile: (source) ->
			if flavor is 'decaf'
				{compile} = require 'decafjs'
				compile source
				#exec "decaf -r '#{file}'"
			else
				{convert} = require 'decaffeinate'
				{code} = convert source
				return code
				#execSync "decaffeinate <<< '#{source}'"
