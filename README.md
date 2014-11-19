Autoform File
=============

Upload and manage files with autoForm.

![Meteor autoform file](https://raw.githubusercontent.com/yogiben/meteor-autoform-file/master/readme/1.png)

**App broken?** This package has recently undergone some app-breaking changes in light of autoform's recent updates. To fix, define your schema as in the tutorial below and replace your `afFileUpload` templates with `afQuickField`. Sorry for any inconvenience caused.

###Setup###
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
```
###Security & optimization###
The above example is just a starting point. You should set your own custom `allow` rules and optimize your subscriptions.
