Package.describe({
  name: "yogiben:autoform-file",
  summary: "File upload for AutoForm",
  description: "File upload for AutoForm",
  version: "0.2.9",
  git: "http://github.com/yogiben/autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use([
    'coffeescript',
    'underscore',
    'reactive-var',
    'templating',
    'less@1.0.0 || 2.5.0',
    'aldeed:autoform@5.4.0',
    'fortawesome:fontawesome@4.4.0'
  ]);

  api.addFiles('lib/client/autoform-file.html', 'client');
  api.addFiles('lib/client/autoform-file.less', 'client');
  api.addFiles('lib/client/autoform-file.coffee', 'client');
  api.addFiles('lib/server/publish.coffee', 'server');
});
