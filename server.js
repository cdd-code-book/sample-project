var express = require('express'),
    packageManifest = require('./package.json');

var app = express();

app.set('port', process.env.PORT || 2001);
 
app.get('/', function (req, res) {
  res.send('Hello World! Running server version: ' + packageManifest.version);
});
 
app.listen(app.get('port'), function() {
  console.log('Server is up and running on port:', app.get('port'));
});
