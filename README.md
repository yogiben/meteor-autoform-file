Autofom File
=============

Upload and manage files with #autoForm.

Examples written in coffeescript and make for an insecure app; anyone can upload / download any file.

1) Install `meteor add yogiben:autoform-file`

2) Create your collectionFS (See [collectionFS](https://github.com/CollectionFS/Meteor-CollectionFS))
```
@Images = new FS.Collection("images",
  stores: [new FS.Store.GridFS("images", {})]
)
```
3) Make sure the correct allow rules & subscriptions are set up
```
Images.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fieldNames, modifier) ->
    true
  download: (userId)->
    true
```
and
```
Meteor.publish 'images', ->
  Images.find()
```
and in your router.coffee
```
  @route "profile",
    waitOn: ->
      [
        Meteor.subscribe 'images'
      ]
```
4) Create an autoForm template
```
{{#autoForm id="profilePicture" type='update' collection=Users doc=User}}
  {{> afFileUpload name="profile.profilePicture" collection='Images'}}
	<button type="submit" class="btn btn-primary">Update</button>
{{/autoForm}}
```
The `afFieldUpload` is the first part of this tutorial unique to this package.

The `name` property is the field name as per your [collection2](https://github.com/aldeed/meteor-collection2) schema.

The `collection` is the name of your FS.Collection.
