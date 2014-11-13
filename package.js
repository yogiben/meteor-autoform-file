Package.describe({
  summary: "Upload and manage files easily with AutoForm and CollectionFS",
  version: "0.0.3",
  git: "http://github.com/yogiben/autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'aldeed:autoform@4.0.2'
    ],
    'client');

  api.add_files('lib/client/autoform-file.html', 'client');
  api.add_files('lib/client/autoform-file.less', 'client');
  api.add_files('lib/client/autoform-file.coffee', 'client');
});
