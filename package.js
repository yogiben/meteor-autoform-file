Package.describe({
  name: "rapito:autoform-file",
  summary: "File upload for AutoForm",
  description: "File upload for AutoForm",
  version: "0.3.2",
  git: "http://github.com/yogiben/autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less@1.0.0 || 2.5.0',
    'aldeed:autoform@4.0.0 || 5.0.0',
    'fortawesome:fontawesome@4.3.0'
    ],
    'client');

  api.add_files('lib/client/autoform-file.html', 'client');
  api.add_files('lib/client/autoform-file.less', 'client');
  api.add_files('lib/client/autoform-file.coffee', 'client');
});
