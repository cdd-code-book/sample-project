var express = require('express'),
    cidrMatcher = require('cidr_match'),
    packageManifest = require('./package.json'),
    config = require('./config'),
    loggly = require('loggly');

var app = express();

app.set('port', process.env.PORT || 2001);
app.set('views', __dirname + '/views');
app.set('view engine', 'hbs');

var logglyClient;

if (process.env.LOGGLY_TOKEN && process.env.LOGGLY_SUBDOMAIN) {
  logglyClient = loggly.createClient({
    token: process.env.LOGGLY_TOKEN,
    subdomain: process.env.LOGGLY_SUBDOMAIN,
    tags: ['webserver'],
    json: true
  });
} else {
  console.warn('The following environment variables need be defined to enable uploading of logs to Loggly:',
    'LOGGLY_TOKEN and LOGGLY_SUBDOMAIN');
}

// Log to stdout plus loggly if configured
function log () {
  if (!arguments) {
    throw new Error('No arguments?!');
  }

  console.log.apply(this, arguments);

  if (logglyClient) {
    logglyClient.log.apply(logglyClient, arguments);
  }
}

app.get('/', function (request, response) {
  var userInfo = getUserInfo(request);

  // Very simple request logging
  log({
    message: 'HTTP Request: ' + request.method + ' ' + request.url,
    userInfo: userInfo,
    userAgent: request.headers['user-agent']
  });

  response.render('index', { userInfo: userInfo, serverVersion: packageManifest.version });
});

app.listen(app.get('port'), function() {
  log('Server is up and running on port: ' + app.get('port'));
  log('Server version: ' + packageManifest.version);
});

function getUserInfo (request) {
  var ip = request.headers['x-forwarded-for'] || request.connection.remoteAddress;

  var result = {
    features: {},
    ip: ip
  };

  config.userGroups.forEach(function (group) {
    if (isIpInAnyRange(ip, group.ipRanges)) {
      // Set group name only if it's not already set
      // I.e. usergroups higher in the config file take precedence
      result.groupName = result.groupName || group.name;

      group.featuresEnabled.forEach(function (featureName) {
        result.features[featureName] = true;
      });
    }
  });

  return result;
}

function isIpInAnyRange (ip, ipRanges) {
  // Returns true if there exists some (any) range that matches the IP
  return ipRanges.some(function (range) {
    return cidrMatcher.cidr_match(ip, range);
  });
}
