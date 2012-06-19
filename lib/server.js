// Generated by CoffeeScript 1.3.3
var child, createServer, express, path, runServer;

child = require('child_process');

express = require('express');

path = require('path');

createServer = function(cb) {
  var app,
    _this = this;
  app = express.createServer();
  this.readConfig(app.settings.env);
  app.configure(function() {
    app.set('port', _this.options.port);
    if (path.existsSync(_this.options["public"])) {
      return app.use(express["static"](_this.options["public"]));
    } else {
      return app.use(express["static"]('.'));
    }
  });
  app.configure('test', function() {
    return app.set('port', _this.options.port + 1);
  });
  app.configure('development', function() {
    app.use(express.logger());
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.configure('production', function() {
    return app.use(express.errorHandler());
  });
  app.get(this.options.cssPath, function(req, res) {
    res.header('Content-Type', 'text/css');
    return res.send(_this.cssPackage().compile());
  });
  app.get(this.options.jsPath, function(req, res) {
    res.header('Content-Type', 'application/javascript');
    return res.send(_this.hemPackage().compile());
  });
  app.run = function(cb) {
    app.listen(app.settings.port, function() {
      console.log("" + app.settings.env + " server up and running at http://localhost:" + (app.address().port));
      if (cb) {
        return cb();
      }
    });
    return app;
  };
  if (cb) {
    cb.call(app);
  }
  return app;
};

runServer = function() {
  var app;
  app = createServer.call(this);
  return app.run(function() {
    if (process.platform === 'darwin') {
      return child.exec("open http://localhost:" + (app.address().port), function() {});
    }
  });
};

module.exports = {
  createServer: createServer,
  runServer: runServer
};