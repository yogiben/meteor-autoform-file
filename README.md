Autoform File
=============

### Description
Upload and manage files with autoForm via [`ostrio:files`](https://github.com/VeliovGroup/Meteor-Files). This package was ported from `yogiben:autoform-file` to use with [`ostrio:files`](https://github.com/VeliovGroup/Meteor-Files) instead of the already deprecated CollectionFS.

### Quick Start:

 - Install `meteor add ostrio:autoform-files`
 - Install `meteor add ostrio:files`, *if not yet installed*
 - Create your Files Collection (See [`ostrio:files`](https://github.com/VeliovGroup/Meteor-Files))
```javascript
var Images = new FilesCollection({
  collectionName: 'Images',
  allowClientCode: false, // Disallow remove files from Client,
  onBeforeUpload: function (file) {
    // Allow upload files under 10MB, and only in png/jpg/jpeg formats
    if (file.size <= 10485760 && /png|jpg|jpeg/i.test(file.ext)) {
      return true;
    } else {
      return 'Please upload image, with size equal or less than 10MB';
    }
  }
})

if (Meteor.isClient) {
  Meteor.subscribe('files.images.all');
}

if (Meteor.isServer) {
  Meteor.publish('files.images.all', function () {
    return Images.collection.find({});
  });
}
```
__Note:__ `Images` variable must be attached to *Global* scope. And has same name (*case-sensitive*) as `collectionName` option passed into `FilesCollectio#insert({collectionName: 'Images'})` method, `Images` in our case.

 - Define your schema and set the `autoform` property like in the example below
```javascript
Schemas = {};
Posts   = new Meteor.Collection('posts');
Schemas.Posts = new SimpleSchema({
  title: {
    type: String,
    max: 60
  },
  picture: {
    type: String,
    autoform: {
      afFieldInput: {
        type: 'fileUpload',
        collection: 'Images'
      }
    }
  }
});

Posts.attachSchema(Schemas.Posts);
```

The `collection` property must be the same as name of your *FilesCollection* (*case-sensitive*), `Images` in our case.

 - Generate the form with `{{> quickform}}` or `{{#autoform}}`
e.g.:
```html
{{> quickForm collection="Posts" type="insert"}}
<!-- OR -->
{{#autoForm collection="Posts" type="insert"}}
  {{> afQuickField name="title"}}
  {{> afQuickField name="picture"}}
  <button type="submit" class="btn btn-primary">Insert</button>
{{/autoForm}}
```

### Multiple images //does not support yet
If you want to use an array of images inside you have to define the autoform on on the [schema key](https://github.com/aldeed/meteor-simple-schema#schema-keys)

```javascript
Schemas.Posts = new SimpleSchema({
  title: {
    type: String,
    max: 60
  },
  pictures: {
    type: [String],
    label: 'Choose file' # optional
  },
  "pictures.$": {
    autoform: {
      afFieldInput: {
        type: 'fileUpload',
        collection: 'Images'
      }
    }
  }
})
```

### Custom file preview /// need to work on this

Your custom file preview template data context will be:

- *file* - FS.File instance
- *atts* - autoform atts

```javascript
picture: {
  type: String,
  autoform: {
    afFieldInput: {
      type: 'fileUpload',
      collection: 'Images',
      previewTemplate: 'myFilePreview'
    }
  }
}
```

```html
<template name="myFilePreview">
  <a href="{{fileURL file}}">{{file.original.name}}</a>
</template>
```
