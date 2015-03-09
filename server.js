var express = require('express'),
    cidrMatcher = require('cidr_match'),
    packageManifest = require('./package.json'),
    config = require('./config');

var app = express();

app.set('port', process.env.PORT || 2001);

app.get('/', function (request, response) {
  var userInfo = getUserInfo(request);

  var message = '';

  if (userInfo.features.holdingPage) {
    message += 'Hello ' + userInfo.groupName + '!';
  }

  if (userInfo.features.serverVersionInfo) {
    message += ' Running server version: ' + packageManifest.version;
  }

  response.send(message);
});

app.listen(app.get('port'), function() {
  console.log('Server is up and running on port:', app.get('port'));
});

function getUserInfo (request) {
  var ip = request.headers['x-forwarded-for'] || request.connection.remoteAddress;

  var result = {
    features: {}
  };

  config.userGroups.forEach(function (group) {
    if (cidrMatcher.cidr_match(ip, group.ipRange)) {
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
