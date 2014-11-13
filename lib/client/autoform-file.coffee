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
	else if file.indexOf('http://') > -1 || file.indexOf('https://') > -1
		icon = 'link'
	icon

getTemplate = (file)->
	template = 'fileThumbIcon'
	if file.indexOf('.jpg') > -1 || file.indexOf('.png') > -1 || file.indexOf('.gif') > -1
		template = 'fileThumbImg'
	template

# Template.afFileUpload.rendered = () ->
# 	doc = Template.parentData(1)._af.doc
# 	data = Template.currentData()


clearFilesFromSession = ->
	_.each Session.keys, (value, key, index)->
		if key.indexOf('fileUpload') > -1
			Session.set key, ''


AutoForm.addHooks null,
	onSuccess: ->
		clearFilesFromSession()


Template.afFileUpload.destroyed = () ->
	name = @data.name
	Session.set 'fileUpload['+name+']', null

Template.afFileUpload.events
	"change .file-upload": (e, t) ->
		files = e.target.files
		collection = $(e.target).attr('collection')
		window[collection].insert files[0], (err, fileObj) ->
			if err
				console.log err
			else
				name = $(e.target).attr('file-input')
				# console.log $(e.target)
				# console.log fileObj
				$('input[name="'+name+'"]').val(fileObj._id)
				Session.set 'fileUploadSelected['+name+']', files[0].name
				# console.log fileObj
				refreshFileInput name
	'click .file-upload-clear': (e,t)->
		name = $(e.currentTarget).attr('file-input')
		$('input[name="' + name + '"]').val('')
		Session.set 'fileUpload['+name+']', 'delete-file'

Template.afFileUpload.helpers
	fileUpload: (name,collection) ->
		af = Template.parentData(1)._af

		if af &&  af.submitType == 'insert'
			doc = af.doc

		if Session.equals('fileUpload['+name+']', 'delete-file')
			return null
		else if Session.get('fileUpload['+name+']')
			file = Session.get('fileUpload['+name+']')
		else if doc
			if name.indexOf('.') > -1
				name = name.split('.')
				file = doc[name[0]]?[name[1]]
			else
				file = doc[name]
		else
			return null

		if file != '' && file
			if file.length == 17
				if window[collection].findOne({_id:file})
					filename = window[collection].findOne({_id:file}).name()
					src = window[collection].findOne({_id:file}).url()
			else
				filename = file
				src = filename
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