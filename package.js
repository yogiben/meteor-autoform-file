Package.describe({
  name: "ostrio:autoform-files",
  summary: "File upload for AutoForm using ostrio:files",
  description: "File upload for AutoForm using ostrio:files",
  version: "0.1.0",
  git: "https://github.com/VeliovGroup/meteor-autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.3');

  api.use([
    'check',
    'coffeescript',
    'underscore',
    'reactive-var',
    'templating',
    'less@1.0.0 || 2.5.1',
    'aldeed:autoform@5.8.0',
    'ostrio:files@1.5.6'
  ]);

  api.addFiles('lib/client/autoform-file.html', 'client');
  api.addFiles('lib/client/autoform-file.less', 'client');
  api.addFiles('lib/client/autoform-file.coffee', 'client');
  api.addFiles('lib/server/publish.coffee', 'server');
});
