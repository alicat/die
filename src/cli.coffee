path    = require 'path'
program = require 'jade/commander'
pkg     = require '../package.json'

program
  .version(pkg.version)
  .usage('[command] [options]')

program
  .command('build')
  .description('  assemble project')
  .option('-o, --output [dir]', 'output dir')
  .option('-m, --minify', 'minify output')
  .option('--css [in]', 'CSS entrypoint')
  .option('--css-path [out]', 'path to compiled CSS')
  .option('--js [in]', 'Javascript entrypoint')
  .option('--js-path [out]', 'path to compiled Javascript')
  .action (opts) ->
    die = require('./index')
      buildPath: opts.output
      css:
        main: opts.css
        url: opts.cssPath
      js:
        main: opts.js
        url: opts.jsPath
      minify: opts.minify
    die.build()

program
  .command('new [name]')
  .description('  create new project')
  .usage('[name] [options]')
  .option('-t, --template [name]', 'template to use')
  .option('-c, --config [config.json]', 'configuration file to supply context variables from')
  .option('-i, --install', 'run npm install automatically')
  .option('-p, --production', 'only install production dependencies')
  .action (name, opts = {}) ->
    if not name
      return console.log 'Name of project is required'
    require('./create') name, opts

program
  .command('run')
  .description('  serve project')
  .option('-p, --port [number]', 'port to run server on')
  .action (opts) ->
    if opts.port
      process.env.PORT = opts.port
    try
      app = require process.cwd()
    catch err
      app = require './index'
    app.run()

program
  .command('test')
  .description('  run tests')
  .action ->
    require('./test')()

program
  .command('watch')
  .description('  watch for changes and rebuild project')
  .action ->
    die = require('./index')
      base: process.cwd()
    require('./watch') die

help = -> console.log program.helpInformation()

program.parse process.argv

help() unless program.args.length
