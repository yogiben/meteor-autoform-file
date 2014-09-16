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

refreshFileSelect = (name)->

Template.afFileUpload.rendered = () ->
	Session.set 'fileUpload['+name+']', $('input[name="' + name + '"]').val()
	name = this.data.name
	callback = ->
		Session.set 'fileUpload['+name+']', $('input[name="' + name + '"]').val()
		$('.file-upload').removeClass 'invisible'
	setTimeout callback, 10


Template.afFileUpload.destroyed = () ->
	name = this.data.name
	Session.set 'fileUpload['+name+']', ''

Template.afFileUpload.events
	"change .file-upload": (e, t) ->
		files = e.target.files
		collection = $(e.target).attr('collection')
		window[collection].insert files[0], (err, fileObj) ->
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
		Session.set 'fileUpload['+name+']', ''

Template.afFileUpload.helpers
	fileUpload: (name,collection,label) ->
		file = Session.get 'fileUpload['+name+']'
		if file != '' && file
			doc = window[collection].findOne({_id:file})
			filename = window[collection].findOne({_id:file}).name()
			src = window[collection].findOne({_id:file}).url()
			obj = 
				template: getTemplate(filename)
				data:
					src: src
					icon: getIcon(filename)
			obj
	fileUploadSelected: (name)->
		Session.get 'fileUploadSelected['+name+']'