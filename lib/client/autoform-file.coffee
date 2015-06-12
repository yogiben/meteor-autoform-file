AutoForm.addInputType 'fileUpload',
  template: 'afFileUpload'
  valueOut: ->
    @val()

getCollection = (context) ->
	if typeof context.atts.collection == 'string'
		context.atts.collection = FS._collections[context.atts.collection] or window[context.atts.collection]
	return context.atts.collection

getDocument = (context) ->
  collection = getCollection context
  id = Template.instance()?.value?.get?()
  collection?.findOne(id)

Template.afFileUpload.onCreated ->
  @value = new ReactiveVar @data.value

Template.afFileUpload.onRendered ->
  self = @
  $(self.firstNode).closest('form').on 'reset', ->
    self.value.set null

Template.afFileUpload.helpers
  label: ->
    @atts.label or 'Choose file'
  removeLabel: ->
    @atts.removeLabel or 'Remove'
  value: ->
    Template.instance().value.get()
  schemaKey: ->
    @atts['data-schema-key']
  previewTemplate: ->
    doc = getDocument @
    if doc?.isImage()
      'afFileUploadThumbImg'
    else
      'afFileUploadThumbIcon'
  previewData: ->
    getDocument @

Template.afFileUpload.events
  'click .js-select-file': (e, t) ->
    t.$('.js-file').click()

  'change .js-file': (e, t) ->
    files = e.target.files
    collection = getCollection t.data

    collection.insert files[0], (err, fileObj) ->
      if err then return console.log err
      t.value.set fileObj._id

  'click .js-remove': (e, t) ->
    e.preventDefault()
    t.value.set null

Template.afFileUploadThumbIcon.helpers
  icon: ->
    switch @extension()
      when 'pdf'
        'file-pdf-o'
      when 'doc', 'docx'
        'file-word-o'
      when 'ppt', 'avi', 'mov', 'mp4'
        'file-powerpoint-o'
      else
        'file-o'
