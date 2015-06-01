var express = require('express'),
    cidrMatcher = require('cidr_match'),
    packageManifest = require('./package.json'),
    config = require('./config');

var app = express();

app.set('port', process.env.PORT || 2001);
app.set('views', __dirname + '/views');
app.set('view engine', 'hbs');

app.get('/', function (request, response) {
  var userInfo = getUserInfo(request);

  response.render('index', { userInfo: userInfo, serverVersion: packageManifest.version });
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
