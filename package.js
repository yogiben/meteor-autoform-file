Package.describe({
  name: "ostrio:autoform-files",
  summary: "File upload for AutoForm using ostrio:files",
  description: "File upload for AutoForm using ostrio:files",
  version: "1.0.0",
  git: "https://github.com/VeliovGroup/meteor-autoform-file.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.4');

  api.use([
    'check',
    'underscore',
    'reactive-var',
    'templating',
    'aldeed:autoform@5.8.0',
    'ostrio:files@1.6.9'
  ]);

  api.addFiles('lib/client/autoform.js', 'client');
  api.addFiles('lib/client/fileUpload.html', 'client');
  api.addFiles('lib/client/fileUpload.js', 'client');
  api.addFiles('lib/client/uploadImageDemo.html', 'client');
});
