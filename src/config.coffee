path   = require 'path'

exports.defaults = require './defaults'

exports.readConfig = (options, name = 'defaults') ->
  configPath = path.join process.cwd(), options.configPath, name
  if path.existsSync configPath
    try
      config = require configPath
      for key, value of config
        options[key] = value
    catch err
  options
