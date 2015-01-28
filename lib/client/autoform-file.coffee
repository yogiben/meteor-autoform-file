AutoForm.addInputType 'fileUpload', {
	template: 'afFileUpload'
}

refreshFileInput = (name)->
	callback = ->
		# id = $('.nav-pills[file-input="'+name+'"] > .active > a').attr('href')
		# value = $('.tab-content[file-input="'+name+'"] >' + id + '>div>input').val()
		# $('input[name="' + name + '"]').val(value)
		# console.log name
		value = $('input[name="' + name + '"]').val()
		Session.set 'fileUpload['+name+']', value
	setTimeout callback, 10

getIcon = (file)->
	if file
		file = file.toLowerCase()
		icon = 'file-o'
		if file.indexOf('youtube.com') > -1
			icon = 'youtube'
		else if file.indexOf('vimeo.com') > -1
			icon = 'vimeo-square'
		else if file.indexOf('.pdf') > -1
			icon = 'file-pdf-o'
		else if file.indexOf('.doc') > -1 || file.indexOf('.docx') > -1
			icon = 'file-word-o'
		else if file.indexOf('.ppt') > -1
			icon = 'file-powerpoint-o'
		else if file.indexOf('.avi') > -1 || file.indexOf('.mov') > -1 || file.indexOf('.mp4') > -1
			icon = 'file-movie-o'
		else if file.indexOf('.png') > -1 || file.indexOf('.jpg') > -1 || file.indexOf('.gif') > -1 || file.indexOf('.bmp') > -1
			icon = 'file-image-o'
		else if file.indexOf('http://') > -1 || file.indexOf('https://') > -1
			icon = 'link'
		icon

getTemplate = (file)->
	file = file.toLowerCase()
	template = 'fileThumbIcon'
	if file.indexOf('.jpg') > -1 || file.indexOf('.png') > -1 || file.indexOf('.gif') > -1
		template = 'fileThumbImg'
	template

clearFilesFromSession = ->
	_.each Session.keys, (value, key, index)->
		if key.indexOf('fileUpload') > -1
			Session.set key, ''

getCollection = (context) ->
	if typeof context.atts.collection == 'string'
		context.atts.collection = FS._collections[context.atts.collection] or window[context.atts.collection]
	return context.atts.collection

AutoForm.addHooks null,
	onSuccess: ->
		clearFilesFromSession()

Template.afFileUpload.destroyed = () ->
	name = @data.name
	Session.set 'fileUpload['+name+']', null

Template.afFileUpload.events
	"change .file-upload": (e, t) ->
		files = e.target.files

		collection = getCollection(t.data)
		collection.insert files[0], (err, fileObj) ->
			if err
				console.log err
			else
				name = $(e.target).attr('file-input')
				# console.log $(e.target)
				# console.log fileObj
				$('input[name="' + name + '"]').val(fileObj._id)
				Session.set 'fileUploadSelected[' + name + ']', files[0].name
				# console.log fileObj
				refreshFileInput name
	'click .file-upload-clear': (e, t)->
		name = $(e.currentTarget).attr('file-input')
		$('input[name="' + name + '"]').val('')
		Session.set 'fileUpload[' + name + ']', 'delete-file'

Template.afFileUpload.helpers
	collection: ->
		getCollection(@)
	label: ->
		@atts.label or 'Choose file'
	fileUploadAtts: ->
		atts = _.clone(this.atts)
		delete atts.collection
		atts
	fileUpload: ->
		af = Template.parentData(1)._af
		# Template.parentData(4).value

		name = @atts.name
		collection = getCollection(@)

		if af &&  af.submitType == 'insert'
			doc = af.doc

		if Session.equals('fileUpload['+name+']', 'delete-file')
			return null
		else if Session.get('fileUpload['+name+']')
			file = Session.get('fileUpload['+name+']')
		else if Template.parentData(4).value
			file = Template.parentData(4).value
		else
			return null

		if file != '' && file
			if file.length == 17
				if collection.findOne({_id:file})
					filename = collection.findOne({_id:file}).name()
					src = collection.findOne({_id:file}).url()
				else
					# No subscription
					filename = Session.get 'fileUploadSelected[' + name + ']'
					obj =
						template: 'fileThumbIcon'
						data:
							src: filename
							icon: getIcon filename
					return obj
			else
				filename = file
				src = filename
		if filename
			obj = 
				template: getTemplate(filename)
				data:
					src: src
					icon: getIcon(filename)
			obj
	fileUploadSelected: (name)->
		Session.get 'fileUploadSelected['+name+']'
	isUploaded: (name,collection) ->
		file = Session.get 'fileUpload['+name+']'
		isUploaded = false
		if file && file.length == 17
			doc = window[collection].findOne({_id:file})
			isUploaded = doc.isUploaded()
		else
			isUploaded = true
		isUploaded

	getFileByName: (name,collection)->
		file = Session.get 'fileUpload['+name+']'
		if file && file.length == 17
			doc = window[collection].findOne({_id:file})
			console.log doc
			doc
		else
			null