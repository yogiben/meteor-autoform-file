Package.describe({
  summary: "Upload and manage files easily with AutoForm and CollectionFS",
  version: "0.0.2",
  git: "http://github.com/yogiben/autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1.1');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less'
    ],
    'client');

  api.add_files('lib/client/autoform-file.html', 'client');
  api.add_files('lib/client/autoform-file.less', 'client');
  api.add_files('lib/client/autoform-file.coffee', 'client');
});
