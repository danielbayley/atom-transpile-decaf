module.exports =
  package: require './package.json'
  #settings: -> atom.config.get @package.name

  activate: ->
    flavor = atom.config.get "#{@package.name}.flavor"
    # TODO live reload menus onDidChange
    name: "transpile-#{flavor}"
    from:
      scopeName: 'source.coffee'
      fileTypes: ['coffee']
    to: scopeName: 'source.js'

    transpile: (source, {softTabs, tabLength}) =>
      if flavor is 'decaf'
        {compile} = @loophole -> require 'decafjs'
        options =
          #reuseWhitespace: false
          useTabs: not softTabs
          tabWidth: tabLength
        @loophole -> compile source, options
        #exec "decaf -r '#{file}'"
      else
        {convert} = require 'decaffeinate'
        {code} = convert source
        return code
        #execSync "decaffeinate <<< '#{source}'"

  loophole: (fn) ->
    {allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
    allowUnsafeNewFunction -> allowUnsafeEval -> fn()
