var express = require('express'),
    cidrMatcher = require('cidr_match'),
    packageManifest = require('./package.json');

var app = express();

app.set('port', process.env.PORT || 2001);

var SUPER_ADMIN_IP_ADDRESS_RANGE = '31.221.0.0/16';

app.get('/', function (request, res) {
  var ip = request.headers['x-forwarded-for'] || request.connection.remoteAddress;

  var userIsSuperAdmin = cidrMatcher.cidr_match(ip, SUPER_ADMIN_IP_ADDRESS_RANGE);

  if (userIsSuperAdmin) {
    res.send('Hello Super Admin! Running server version: ' + packageManifest.version);
  } else {
    res.send('Hello World!');
  }
});

app.listen(app.get('port'), function() {
  console.log('Server is up and running on port:', app.get('port'));
});
