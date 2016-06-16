Autoform File
=============

### Description ###
Upload and manage files with autoForm using ostrio:files.
This was ported from yogiben:autoform-file to use ostiro:files instead of the now deprecated CollectionFS.

### Quick Start ###
1) Install `meteor add ostrio:autoform-files`

2) Create your Files Collection (See [osiro:files](https://github.com/VeliovGroup/Meteor-Files.git))
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
4) Define your schema and set the `autoform` property like in the example below
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
        label: 'Choose file' # optional
      }
    }
  }
});

Posts.attachSchema(Schemas.Posts);
```

The `collection` property is the field name of your files collection.

5) Generate the form with `{{> quickform}}` or `{{#autoform}}`

e.g.
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

###Multiple images###
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

### Customization ###
You can customize the button / remove text.

Defaults:
```
{{> afFieldInput name="picture" label="Choose file" remove-label="Remove"}}
```

Also it is possible to customize accept attribute

add it in your schema definition:
```javascript
picture: {
  type: String,
  autoform: {
    afFieldInput: {
      type: 'fileUpload',
      collection: 'Images',
      accept: 'image/*',
      label: 'Choose file' # optional
    }
  }
}

```
### Custom file preview ###

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

### Custom select/remove file buttons ###

Remember to add `js-af-select-file` and `js-af-remove-file` classes to nodes which should fire an event on click.

```javascript
picture: {
  type: String,
  autoform: {
    afFieldInput: {
      type: 'fileUpload',
      collection: 'Images',
      selectFileBtnTemplate: 'mySelectFileBtn',
      removeFileBtnTemplate: 'myRemoveFileBtn'
    }
  }
}
```

```html
<template name="mySelectFileBtn">
  <button type="button" class="js-af-select-file">Upload file</button>
</template>

<template name="myRemoveFileBtn">
  <button type="button" class="js-af-remove-file">Remove</button>
</template>
```

### Callbacks ###

**onBeforeInsert** - can be used to modify file (remember to return fileObj)

**onAfterInsert** - called after insert with two arguments: error object and file object

Please note that callback properties are functions that return callbacks. This is because autoform evaluates function attributes first.

```javascript
picture: {
  type: String,
  autoform: {
    afFieldInput: {
      type: 'fileUpload',
      collection: 'Images',
      onBeforeInsert(fileObj) {
        fileObj.name = 'picture.png';
        fileObj
      },
      onAfterInsert(err, fileObj) {
        if err
          alert 'Error'
        else
          alert 'Upload successful'
      }
    }   
  }
}
```
