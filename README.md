Autoform File
=============

### Description
Upload and manage files with autoForm using ostrio:files.
This was ported from yogiben:autoform-file to use ostiro:files instead of the now deprecated CollectionFS.

### Quick Start
##### 1. Install `meteor add ostrio:autoform-files`
##### 2. Create your Files Collection (See [ostrio:files](https://github.com/VeliovGroup/Meteor-Files.git))
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
##### 3. Define your schema and set the `autoform` property like in the example below
```javascript
Schemas = {}

Posts = new Meteor.Collection('posts');

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
        collection: 'Images',
      }
    }
  }
});

Posts.attachSchema(Schemas.Posts);
```

The `collection` property is the field name of your files collection.

##### 4. Generate the form with `{{> quickform}}` or `{{#autoform}}`
e.g.:
```
{{> quickForm collection="Posts" type="insert"}}
```

or

```
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
  <a href="{{file.url}}">{{file.original.name}}</a>
</template>
```
