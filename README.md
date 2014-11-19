Autoform File
=============

To do:
* Integrate `cfs:ui`

Upload and manage files with #autoForm.

Examples written in coffeescript and make for an insecure app; anyone can upload / download any file.

1) Install `meteor add yogiben:autoform-file`

2) Create your collectionFS (See [collectionFS](https://github.com/CollectionFS/Meteor-CollectionFS))
```
@Images = new FS.Collection("images",
  stores: [new FS.Store.GridFS("images", {})]
)
```
3) Make sure the correct allow rules & subscriptions are set up on the collectionFS
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
4) Define your schema and set the `autoform` property like in the example below
```
Schemas = {}

@Posts = new Meteor.Collection('posts');

Schemas.Posts = new SimpleSchema
	title:
		type:String
		max: 60
		
	picture:
		type: String
		autoform:
			afFieldInput:
				type: 'fileUpload'
				collection: 'Images'

Posts.attachSchema(Schemas.Posts)
```

The `collection` property is the field name of your collectionFS.

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
